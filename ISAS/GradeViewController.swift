//
//  GradeViewController.swift
//  ISAS
//
//  Created by Adam Salih on 08/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit

class GradeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeTable: TimeTableView!
    @IBOutlet weak var subjectTable: SubjectTableView!
    @IBOutlet weak var navBar: UIVisualEffectView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var shouldRefresh = true
    @IBOutlet weak var tableWidthConstrain: NSLayoutConstraint!
    @IBOutlet weak var TableYOrigin: NSLayoutConstraint!
    var gesture:GestureDelegate!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let user = Database.getUser()!
        self.nameLabel.text = user.name!
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.indicator.alpha = 0
        self.gesture = GestureDelegate(screen: self, movableConstrain: self.TableYOrigin)
        let panGesture = UIPanGestureRecognizer(target: self.gesture, action: "panGesture:")
        panGesture.delegate = self.gesture
        self.view.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.shouldRefresh{
            self.refresh()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillLayoutSubviews() {
        if self.gesture.xOrientation == nil{// to find whether it is the gesture who is calling this method
            if self.traitCollection.horizontalSizeClass == .Compact{
                self.tableWidthConstrain.constant = self.view.frame.width
                self.gesture.activated = true
            }else if self.traitCollection.horizontalSizeClass == .Regular{
                self.tableWidthConstrain.constant = self.view.frame.width / 2
                self.gesture.activated = false
            }
            NSNotificationCenter.defaultCenter().postNotificationName("ResizeHeaderView", object: self.tableWidthConstrain.constant)
            self.TableYOrigin.constant = -20
        }
    }
    
    /**
     This method shows alert messge to the user.
     
     - Parameter title: title of the message.
     
     - Parameter message: message it self.
     */
    
    func showAlert(title title:String, message:String){
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                (_) in
                UIView.animateWithDuration(0.4, animations: {
                    self.refreshButton.alpha = 1
                    self.indicator.alpha = 0
                })
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        });
    }
    
    /**
     This method removes all users data and segue back to login screen.
    */

    @IBAction func logout() {
        Database.removeAllData()
        self.performSegueWithIdentifier("logoutSegue", sender: self)
    }
    
    /**
     This method downloads new grades and reloads tableViews with new data.
    */
    
    @IBAction func refresh() {
        self.indicator.startAnimating()
        UIView.animateWithDuration(0.4, animations: {
            self.refreshButton.alpha = 0
            self.indicator.alpha = 1
        })
        let myQueue:dispatch_queue_t = dispatch_queue_create("Refresh", nil)
        dispatch_async(myQueue , {
            do{
                let user = Database.getUser()!
                try SyncEngine.logIn(username: user.username!, password: user.password!)
                let gradesData = try SyncEngine.getGrades()
                let dicGrades = try Parser.getGrades(data: gradesData)
                Database.refreshGrades(grades:dicGrades)
                dispatch_async(dispatch_get_main_queue(), {
                    self.timeTable.reloadData()
                    self.subjectTable.reloadData()
                    UIView.animateWithDuration(0.4, animations: {
                        self.refreshButton.alpha = 1
                        self.indicator.alpha = 0
                    })
                })
                self.indicator.stopAnimating()
            }catch let error as SyncError{
                self.showAlert(title: "Chyba", message: error.description)
            }catch let error as ParseError{
                self.showAlert(title: "Chyba", message: error.description)
            }catch{
                self.showAlert(title: "Chyba", message: "Vyskytla se neznámá chyba.")
            }
        })
    }
}

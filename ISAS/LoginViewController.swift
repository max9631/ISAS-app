//
//  LoginViewController.swift
//  ISAS
//
//  Created by Adam Salih on 08/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var textDel:TextFieldDelegate!
    var foreground: LoadingScreen!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textDel = TextFieldDelegate()
        self.usernameTextField.delegate = textDel
        self.passwordTextField.delegate = textDel
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let GradeView = segue.destinationViewController as! GradeViewController
        GradeView.shouldRefresh = false
    }
    
    /**
     This method loads a loading screen and shows it to user while obtaining necessary data.
     
     - Parameter start: set to true, if you want to set Foreground Active, otherwise false
     
     - Parameter withLabel: String which will be set to the foreground
     */
    
    func setForeGround(active start:Bool, withLabel str:String){
        if start{
            let height = UIScreen.mainScreen().bounds.height
            let width = UIScreen.mainScreen().bounds.width
            self.foreground = LoadingScreen(effect: UIBlurEffect(style: .Dark))
            foreground.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.view.addSubview(foreground)
            self.foreground.startWith(str)
            foreground.alpha = 0
            UIView.animateWithDuration(0.4, animations: {
                self.foreground.alpha = 1
            })
        }else{
            self.foreground.setLabel(text: str)
            UIView.animateWithDuration(0.6, animations: {
                self.foreground.alpha = 0
            }, completion: { (bl:Bool) in
                self.foreground.removeFromSuperview()
                self.foreground = nil
            })
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
                self.setForeGround(active: false, withLabel: title)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        });
    }
    
    /**
     This method reacts to the event of activated (touch up inside) button in the login view controller. This method logs in to the SAS server, obtains users fullname, downloads a site with users grades, parses it and saves it
     */
    
    @IBAction func login() {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.setForeGround(active: true, withLabel: "Přihlašování")
        if self.usernameTextField.text == "" || self.passwordTextField.text == ""{
            self.showAlert(title: "Chyba", message: "Zkontrolujte si zadané údaje")
            return
        }
        let myQueue:dispatch_queue_t = dispatch_queue_create("login", nil)
        dispatch_async(myQueue , {
            do{
                let userData = try SyncEngine.logIn(username: self.usernameTextField.text! , password: self.passwordTextField.text!)
                self.foreground.setLabel(text: "Získávání jména")
                let fullname = try Parser.getUser(data: userData)!
                self.foreground.setLabel(text: "Stahování známek")
                let gradesData = try SyncEngine.getGrades()
                self.foreground.setLabel(text: "Ukládání známek")
                let grades = try Parser.getGrades(data: gradesData)
                Database.saveGrades(grades)
                Database.saveUser([
                    "Fullname":fullname,
                    "Username":self.usernameTextField.text!,
                    "Password":self.passwordTextField.text!])
                self.foreground.setLabel(text: "Hotovo")
                let delay = 1 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(),{
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                })
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


//
//  GestureDelegate.swift
//  ISAS
//
//  Created by Adam Salih on 18/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit

class GestureDelegate: NSObject, UIGestureRecognizerDelegate {
    
    var originPosition:CGPoint!
    var mainView:UIView!
    var const:NSLayoutConstraint!
    var timeSelected:Bool!
    var xOrientation:Bool?
    
    init(screen:GradeViewController, movableConstrain:NSLayoutConstraint){
        self.mainView = screen.view
        self.const = movableConstrain
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /**
     This method specifies a behaviour of a gesture in GradeViewController.
     
     - Parameter gesture: An instance of the pan gesture object.
    */
    
    func panGesture(gesture:UIPanGestureRecognizer){
        switch gesture.state{
        case.Began:
            self.originPosition = gesture.locationInView(self.mainView)
            if self.const.constant == -20{
            	self.timeSelected = true
            }else{
            	self.timeSelected = false
            }
        case .Ended:
        	let width = UIScreen.mainScreen().bounds.width
        	var finalPos:CGFloat
            if self.timeSelected == true{
                if (self.const.constant + 20) > -(width / 4){
                    finalPos = -20
                }else{
                    finalPos = -width - 20
                    self.timeSelected = false
                }
            }else{
                if (self.const.constant + 20) > -(width / 4)*3{
                    finalPos = -20
                    self.timeSelected = true
                }else{
                    finalPos = -width - 20
                }
            }
            UIView.animateWithDuration(0.2, animations: {
                self.const.constant = finalPos
                self.mainView.layoutIfNeeded()
            })
            self.xOrientation = nil
        default:
        	let deltaX = gesture.locationInView(self.mainView).x - self.originPosition.x
            if self.xOrientation == nil{
                let deltaY = gesture.locationInView(self.mainView).y - self.originPosition.y
                self.xOrientation = abs(deltaX)>abs(deltaY)
            }
            if self.xOrientation == true{
                if self.timeSelected == true{
                    if deltaX > 0{
                        self.const.constant = -20 + (deltaX/3)
                    }else{
                        self.const.constant = -20 + deltaX
                    }
                }else{
                    let width = UIScreen.mainScreen().bounds.width
                    if deltaX < 0{
                        self.const.constant = -20 - width + (deltaX/3)
                    }else{
                        self.const.constant = -20 - width + deltaX
                    }
                }
            }
        }
    }
}

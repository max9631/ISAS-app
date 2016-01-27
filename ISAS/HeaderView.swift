//
//  HeaderView.swift
//  ISAS
//
//  Created by Adam Salih on 14/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    var averageLabel:UILabel?
    var subjectLabel:UILabel?
    
    init(withWidth width:CGFloat){
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 18))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resize:", name: "ResizeHeaderView", object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resize(notification:NSNotification){
        let newWidth = notification.object as! CGFloat
        self.frame.size.width = newWidth
        if let sLabel = self.subjectLabel{
            sLabel.frame.size.width = newWidth - 64
        }
        if let aLabel = self.averageLabel{
            aLabel.frame.origin.x = newWidth - 54
        }
    }
    
    /**
     This method set the subjectLabel with a name of subject.
     
     - Parameter width: A table view width.
     
     - Parameter subject: A name of the subject.
    */
    
    func setSubject(subject:String){
        self.backgroundColor = UIColor.clearColor()
        if self.subjectLabel == nil{
            let width = self.frame.width
            self.subjectLabel = UILabel(frame: CGRect(x: 10, y: 6, width: width - 64, height: 16))
            self.subjectLabel!.textColor = UIColor.whiteColor()
            self.subjectLabel!.font = UIFont(name: self.averageLabel!.font!.familyName, size: 14)
            self.addSubview(self.subjectLabel!)
        }
        self.subjectLabel!.text = subject
    }
    
    /**
     This method set the averageLabel with average grade.
     
     - Parameter width: A table view width:
     
     - Parameter subject: A name of the subject.
     */
    
    func setAverage(avrg:Float){
        self.backgroundColor = UIColor.clearColor()
        if self.averageLabel == nil{
            let width = self.frame.width
            self.averageLabel = UILabel(frame: CGRect(x: width - 14 - 40, y: 6, width: 40, height: 16))
            self.averageLabel!.textColor = UIColor.whiteColor()
            self.averageLabel!.font = UIFont(name: self.averageLabel!.font!.familyName, size: 14)
            self.averageLabel!.textAlignment = .Right
            self.addSubview(self.averageLabel!)
        }
        self.averageLabel!.text = String(format: "%.2f", avrg)
    }

}

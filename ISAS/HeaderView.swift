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
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 18))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     This method set the subjectLabel with a name of subject.
     
     - Parameter subject: A name of the subject.
    */
    
    func setSubject(subject:String){
        self.backgroundColor = UIColor.clearColor()
        if self.subjectLabel == nil{
            self.subjectLabel = UILabel(frame: CGRect(x: 10, y: 6, width: UIScreen.mainScreen().bounds.width - 64, height: 16))
            self.subjectLabel!.textColor = UIColor.whiteColor()
            self.subjectLabel!.font = UIFont(name: self.averageLabel!.font!.familyName, size: 14)
            self.addSubview(self.subjectLabel!)
        }
        self.subjectLabel!.text = subject
    }
    
    /**
     This method set the averageLabel with average grade.
     
     - Parameter subject: A name of the subject.
     */
    
    func setAverage(avrg:Float){
        self.backgroundColor = UIColor.clearColor()
        if self.averageLabel == nil{
            let width = UIScreen.mainScreen().bounds.width
            self.averageLabel = UILabel(frame: CGRect(x: width - 14 - 40, y: 6, width: 40, height: 16))
            self.averageLabel!.textColor = UIColor.whiteColor()
            self.averageLabel!.font = UIFont(name: self.averageLabel!.font!.familyName, size: 14)
            self.averageLabel!.textAlignment = .Right
            self.addSubview(self.averageLabel!)
        }
        self.averageLabel!.text = String(format: "%.1f", avrg)
    }

}

//
//  PrototypeCell.swift
//  ISAS
//
//  Created by Adam Salih on 13/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit

class PrototypeCell: UITableViewCell {

    @IBOutlet weak var detailedLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = false
    }
    
    /**
     This method shows a border of all cell labels. It is used to debug an autolayout interface.
    */
    
    func showEdges(){
        self.detailedLabel.layer.borderColor = UIColor.redColor().CGColor
        self.detailedLabel.layer.borderWidth = 1
        self.mainLabel.layer.borderWidth = 1
        self.mainLabel.layer.borderColor = UIColor.greenColor().CGColor
    }
    
    /**
     This method sets all properties of the cell.
     
     - Parameter grade: Grade object representing a single grade.
    */
    
    func setCell(grade grade:Grade){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d.M."
        print(grade)
        self.dateLabel.text = "\(formatter.stringFromDate(grade.date!)) \(grade.subject!)"
        self.mainLabel.text = grade.examLabel!
        self.detailedLabel.text = grade.typeOfExam
        self.gradeLabel.text = "\(grade.grade!)"
    }
    
}

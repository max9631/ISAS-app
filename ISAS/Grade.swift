//
//  Grade.swift
//  ISAS
//
//  Created by Adam Salih on 15/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import Foundation
import CoreData


class Grade: NSManagedObject {
    
}

extension Grade {
    
    @NSManaged var date: NSDate?
    @NSManaged var examLabel: String?
    @NSManaged var grade: String?
    @NSManaged var gradeValue: NSNumber?
    @NSManaged var subject: String?
    @NSManaged var teacher: String?
    @NSManaged var typeOfExam: String?
    @NSManaged var weight: NSNumber?
    @NSManaged var id: NSNumber?
    
}

//
//  User.swift
//  ISAS
//
//  Created by Adam Salih on 15/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

}

extension User {
    
    @NSManaged var name: String?
    @NSManaged var password: String?
    @NSManaged var username: String?
    
}
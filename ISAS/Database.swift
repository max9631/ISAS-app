//
//  Database.swift
//  ISAS
//
//  Created by Adam Salih on 12/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit
import CoreData

class Database: NSObject {
    
    /**
     This method gets the core CoreData object NSManagedObjectContext and returns it
     
     - Returns: shared NSManagedObjectContext
     */
    
    class func getManagedObjectContext()->NSManagedObjectContext{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    
    /**
     This method gets all the necessary information about User, creates CoreData NSManagedObject and saves it.
     
     - Parameter user: A dictionarry with fullname, username and password with key "Fullname", "Username" and "Password".
     */
    
    class func saveUser(user:[String:String]){
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: self.getManagedObjectContext())!
        let usr = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.getManagedObjectContext()) as! User
        usr.username = user["Username"]
        usr.name = user["Fullname"]
        usr.password = user["Password"]
        do{
            try self.getManagedObjectContext().save()
        }catch{
            fatalError()
        }
    }
    
    /**
     This method gets an array of grades encapsulated in dictionary, creates instance of Grade, a subclass of NSManagedObject, and saves it.
     
     - Parameter user: A dictionarry with key:object
     - "Datum"          : date as NSDate
     - "Předmět"        : subject as String
     - "Známka"         : grade as String
     - "Hodnota"        : gradeValue as Int
     - "Typ zkoušení"   : typeOfExam as String
     - "Váha"           : weight as Int
     - "Poznámka"       : examLabel as String
     - "Učitel"         : teacher as String
     - "ID"             : id as Int
    
     */
    
    class func saveGrades(grades:[[String:AnyObject]]) -> [Grade]{
        var savedGrades = [] as [Grade]
        for grd in grades{
            let entity = NSEntityDescription.entityForName("Grade", inManagedObjectContext: self.getManagedObjectContext())!
            let grade = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.getManagedObjectContext()) as! Grade
            grade.date = grd["Datum"] as? NSDate
            grade.subject = grd["Předmět"] as? String
            grade.grade = grd["Známka"] as? String
            grade.gradeValue = grd["Hodnota"] as? Float
            grade.typeOfExam = grd["Typ zkoušení"] as? String
            grade.weight = grd["Váha"] as? Int
            grade.examLabel = grd["Poznámka"] as? String
            grade.teacher = grd["Učitel"] as? String
            print("saving: \(grd)")
            grade.id = grd["ID"] as? Int
            print(" saved: \(grade.id as! Int)")
            savedGrades.append(grade)
        }
        do{
            try self.getManagedObjectContext().save()
        }catch{
            fatalError()
        }
        return savedGrades
    }
    
    /**
     This method loads an User instance from CoreData and returns it.
     
     - Returns: User, a subclass of NSManagedObject.
     */
    
    class func getUser() -> User?{
        let request = NSFetchRequest(entityName: "User")
        do{
            let users = try self.getManagedObjectContext().executeFetchRequest(request) as! [User]
            if users.count != 0{
                return users[0]
            }else{
                return nil
            }
        }catch{
            fatalError()
        }
    }
    
    /**
     This method loads an Grade instances from CoreData and returns them.
     
     - Returns: Array of Grade, a subclass of NSManagedObject.
     */
    
    class func getGrades() -> [Grade]{
        let request = NSFetchRequest(entityName: "Grade")
        do{
            return try self.getManagedObjectContext().executeFetchRequest(request) as! [Grade]
        }catch{
            fatalError()
        }
    }
    
    /**
     This method loads array of Grades from CoreData and return number of objects in that array.
     
     - Returns: Number of grades.
     */
    
    class func numberOfGrades() -> Int{
        return self.getGrades().count
    }
    
    /**
     This method iterates through downloaded and already saved grades and finds whether there has been some changes and eventually the new state.
     
     - Parameter grades: An array of downloaded grades.
     
     - Returns: An array of new grades.
    */
    
    class func refreshGrades(var grades webGrades:[[String:AnyObject]]) -> [Grade]{
        func sortFunc(firstInt:Int, secondInt:Int) -> Bool{
            if firstInt < secondInt{
                return false
            }else{
                return true
            }
        }
        var deleteIndexes = [] as [Int]
        var deleteWebIndexes = [] as [Int]
        var grades = self.getGrades()
        for var i = 0; i < webGrades.count; i = i+1{
            let dicID = webGrades[i]["ID"] as! Int
            for var s = 0; s < grades.count; s = s+1{
                if dicID == grades[s].id as! Int{
                    deleteIndexes.append(s)
                    deleteWebIndexes.append(i)
                    break
                }
            }
        }
        for del in deleteIndexes.sort(sortFunc){
            grades.removeAtIndex(del)
        }
        for del in deleteWebIndexes.sort(sortFunc){
            webGrades.removeAtIndex(del)
        }
        for grade in grades{ // grades to remove
            self.getManagedObjectContext().deleteObject(grade)
        }
        return self.saveGrades(webGrades) //grades to add
    }
    
    /**
     This method is used when user logs out to remove all the informations about user.
     */
    
    class func removeAllData(){
        let grades = self.getGrades()
        let user = self.getUser()!
        self.getManagedObjectContext().deleteObject(user)
        for grade in grades{
            self.getManagedObjectContext().deleteObject(grade)
        }
    }
}



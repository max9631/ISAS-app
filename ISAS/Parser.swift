//
//  Parser.swift
//  ISAS
//
//  Created by Adam Salih on 08/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import Foundation
import UIKit
import Kanna

class Parser: NSObject, NSXMLParserDelegate {
    
    /**
     This method checks whether users login informations are correct.
     
     - Parameter data: Servers response after login.
     
     - Returns: Whether user is logged in or not.
    */
    
    class func isLoggedIn(data data:NSData) -> Bool{
        if let doc = Kanna.HTML(html: data, encoding: NSWindowsCP1250StringEncoding){
            if let _ = doc.xpath("//div[@class=\"duvod\"]").innerHTML{
                return false
            }
        }
        return true
    }
    
    /**
     This method parses the passed data and returns users full name.
     
     - Parameter data: NSData of SAS site containing users full name.
     
     - Throws: `ParseError.ivalidData` if the data parameter does not contain wanted information
     
     - Returns: Users fullname
     */
    
    class func getUser(data data:NSData) throws -> String?{
        var name:String?
        if let doc = Kanna.HTML(html: data, encoding: NSWindowsCP1250StringEncoding){
            var namefound = false
            for link in doc.xpath("//table[@id=\"prihlaseny-uzivatel\"]/tr/td"){
                if namefound{
                    name = link.innerHTML!
                    break
                }
                if link.innerHTML == "Jméno:\n"{
                    namefound = true
                }
            }
        }
        if let fullname = name{
            return fullname
        }else{
            throw ParseError.ivalidData
        }
    }
    
    /**
     This method parses the passed data and returns users grades.
        - Datum: NSDate
        - Předmět: String
        - Známka: String
        - Hodnota: Float
        - Typ zkoušení: String
        - Váha: Int
        - Poznámka: String
        - Učitel: String
     
     - Parameter data: NSData of SAS site containing users grades.
     
     - Throws: `ParseError.ivalidData` if the data parameter does not contain wanted information
     
     - Returns: Array of grades
     */
    
    class func getGrades(data data:NSData) throws -> [[String:AnyObject]]{
        var grades:[[String:AnyObject]] = []
        if let doc = Kanna.HTML(html: data, encoding: NSWindowsCP1250StringEncoding){
            var category = 0
            let categoryName = ["Datum", "Předmět", "Známka", "Hodnota", "Typ zkoušení", "Váha", "Poznámka", "Učitel"]
            var firstRow = true
            var grade = [:] as [String:AnyObject]
            for link in doc.xpath("//table[@class=\"isas-tabulka\"]/tr/td"){
                if !firstRow {
                    var foo:AnyObject = link.text as! AnyObject
                    switch category{
                    case 0:
                        let index = link.innerHTML!.startIndex
                        let id = link.innerHTML!.substringWithRange(Range<String.Index>(start: index.advancedBy(73), end: index.advancedBy(80)))
                        grade["ID"] = Int(id)!
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "dd.MM.yyyy"
                        formatter.locale = NSLocale.currentLocale()
                        foo = formatter.dateFromString(foo as! String)!
                    case 3:
                        foo = Float(foo as! String)!
                    case 5:
                        foo = Int(foo as! String)!
                    default:
                        doNothing()
                    }
                    grade[categoryName[category]] = foo
                }
                if category == 7{
                    category = -1
                    if !firstRow{
                        grades.append(grade)
                        grade = [:]
                    }
                    firstRow = false
                }
                category++
            }
            if firstRow{
                throw ParseError.ivalidData
            }
        }
        return grades
    }
    
    /**
     This method does nothing. Absolutely nothing.
     */
    
    class func doNothing() {}
}
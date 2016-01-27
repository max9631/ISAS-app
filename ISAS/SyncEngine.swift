//
//  SyncEngine.swift
//  ISAS
//
//  Created by Adam Salih on 08/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit

let useSchoolServer = true

class SyncEngine: NSObject{
    
    /**
        This method logs into the SAS server using the login informations passed in the parameters, parses the respond, retrievs users full name and returns it.

        - Parameter username: Users username to ISAS.

        - Parameter password: Users password to ISAS.

        - Throws: 
            `SyncError.connectionError` if the user has invalid internet connection.

            `SyncError.communicationError` if the respond is invalid. (e.g. You have to log in to your school wifi first...)
     
            `SyncError.serverIsDown` if the SAS server is down
     
            `SyncError.badLogins` if the user provided bad login informations
     
        - Returns: Users fullname
    */
    
    class func logIn(username username:String, password:String) throws -> NSData{
        var url:NSURL
        if useSchoolServer{
            url = NSURL(string: "https://isas.sspbrno.cz/prihlasit.php")!
        }else{
            url = NSURL(string: "http://90.178.17.71/school/isas/prihlasit.php")!
        }
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let formDataStr = "login-isas-username=\(username)&login-isas-password=\(password)&login-isas-send=isas-send"
        let formData = formDataStr.dataUsingEncoding(NSUTF8StringEncoding)
        var error: SyncError?
        var data: NSData!
        let semaphore = dispatch_semaphore_create(0)
        let task = session.uploadTaskWithRequest(request, fromData: formData, completionHandler: {
            (netData,response,err) in
            guard let _:NSData = netData, let _:NSURLResponse = response  where err == nil else {
                error = SyncError.connectionError
                dispatch_semaphore_signal(semaphore)
                return
            }
            data = netData
            dispatch_semaphore_signal(semaphore)
        });
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        if let actualErr = error{
            throw actualErr
        }
        if !Parser.isLoggedIn(data: data){
            throw SyncError.badLogins
        }
        let path = NSBundle.mainBundle().pathForResource("ErrorMessage", ofType: "html")
        let errorData = NSFileManager.defaultManager().contentsAtPath(path!)
        if data.isEqualToData(errorData!){
            throw SyncError.serverIsDown
        }
        return data
    }
    
    /**
     This method assumes that the user have already logged in so it loads users grades and returns it back.
     
     - Throws:
         `SyncError.connectionError` if the user has invalid internet connection.
         
         `SyncError.serverIsDown` if the SAS server is down
     
     - Returns: NSData with users grades
     */
    
    class func getGrades() throws -> NSData{
        var url:NSURL
        if useSchoolServer{
            url = NSURL(string: "https://isas.sspbrno.cz/prubezna-klasifikace.php")!
        }else{
            url = NSURL(string: "http://90.178.17.71/school/isas/prubezna-klasifikace.php")!
        }
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        var error: SyncError?
        var data: NSData!
        let semaphore = dispatch_semaphore_create(0)
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (netData,response,err) in
            guard let _:NSData = netData, let _:NSURLResponse = response  where err == nil else {
                error = SyncError.connectionError
                dispatch_semaphore_signal(semaphore)
                return
            }
            data = netData
            dispatch_semaphore_signal(semaphore)
            
        });
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        if error != nil{
            throw error!
        }
        let path = NSBundle.mainBundle().pathForResource("ErrorMessage", ofType: "html")
        let errorData = NSFileManager.defaultManager().contentsAtPath(path!)
        if data!.isEqualToData(errorData!){
            throw SyncError.serverIsDown
        }
        return data
    }

}
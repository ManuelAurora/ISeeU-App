//
//  ClientModel.swift
//  ISeeU-App
//
//  Created by Мануэль on 29.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class Client
{
    var students = [[String: AnyObject]]()
    var userData = UserData()
    
    func handleError(error: NSError, controller: UIViewController) {
               
        var alertMessage = ""
        
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        if controller is LoginViewController {
            alertMessage = "Wrong E-mail or Password"
        } else if controller is MapViewController && error.description.containsString("There is no data") {
            alertMessage = "Please, check your internet connection"
        } else if controller is MapViewController {
            alertMessage = "Download fails"
        }
        
        let alert = UIAlertController(title: "Error occured", message: alertMessage, preferredStyle: .Alert)
        alert.addAction(okAction)
        
        controller.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
}

struct UserData
{
    var currentUser = Student()
    var loggedIn = false
}
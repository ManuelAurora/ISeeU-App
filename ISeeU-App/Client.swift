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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
    func loadMainControllers() {
        let tabBarController   = appDelegate.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("MainTabBar") as! UITabBarController
        let navControllers     = tabBarController.viewControllers
        let mapController      = navControllers![0].childViewControllers[0] as! MapViewController
        let studentsController = navControllers![1].childViewControllers[0] as! StudentsTableViewController
        
        
        mapController.client      = self
        studentsController.client = self
        
        appDelegate.window?.rootViewController?.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    func handleError(error: NSError, controller: UIViewController) {
               
        var alertMessage = ""
        
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        if controller is LoginViewController {
            alertMessage = "Wrong E-mail or Password"
            
        } else if controller is MapViewController && error.description.containsString("There is no data") {
            alertMessage = "Please, check your internet connection"
            
        } else if controller is MapViewController {
            alertMessage = "Download fails"
        
        } else if controller is AddNewPinViewController {
            alertMessage = "Can't find this location, please try again"
            
            let contr = controller as! AddNewPinViewController
            
            contr.activityIndicator.hidden = true
            
        } else if controller is PlacePinViewController {
            alertMessage = "Unable to place pin"
            
        } else {
            alertMessage = "Unknown error"
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
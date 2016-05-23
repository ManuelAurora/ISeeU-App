//
//  ClientModel.swift
//  ISeeU-App
//
//  Created by Мануэль on 29.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class Manager
{
    var students      = [[String: AnyObject]]()
    var userData      = UserData()
    let appDelegate   = UIApplication.sharedApplication().delegate as! AppDelegate
    let errorHandler  = ErrorHandler()
    
    func loadMainControllers() {
        let tabBarController   = appDelegate.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("MainTabBar") as! UITabBarController
        let navControllers     = tabBarController.viewControllers
        let mapController      = navControllers![0].childViewControllers[0] as! MapViewController
        let studentsController = navControllers![1].childViewControllers[0] as! StudentsTableViewController
                
        mapController.manager      = self
        studentsController.manager = self
        
        let loginController = appDelegate.window!.rootViewController! as! LoginViewController        
        
        let spinner = loginController.loginButton.viewWithTag(666) as! UIActivityIndicatorView
        
        spinner.removeFromSuperview()
        
        loginController.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    class func sharedInstance() -> Manager {
        struct Singleton {
            static let sharedInstance = Manager()
        }
        
        return Singleton.sharedInstance
    }
}

struct UserData
{
    var currentUser = Student()
    var loggedIn = false
}

struct ErrorHandler {
    
    func handleError(error: NSError, controller: UIViewController) {
        
        var alertMessage = ""
        
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        if controller is LoginViewController && error.description.containsString("There is no data") {
            return
        }
            
        else if controller is LoginViewController {
            alertMessage = "Wrong E-mail or Password"
            
            let controller = controller as! LoginViewController
            
            controller.renewMainMenu()            
        }
            
        else if controller is MapViewController && error.description.containsString("There is no data") {
            alertMessage = "Please, check your internet connection"
        }
            
        else if controller is MapViewController {
            alertMessage = "Download fails"
        }
            
        else if controller is AddNewPinViewController {
            alertMessage = "Can't find this location, please try again"
            
            let controller = controller as! AddNewPinViewController
            
            controller.activityIndicator.hidden = true
        }
            
        else if controller is PlacePinViewController {
            alertMessage = "Unable to place pin"
        }
            
        else {
            alertMessage = "Unknown error"
        }
        
        let alert = UIAlertController(title: "Error occured", message: alertMessage, preferredStyle: .Alert)
        alert.addAction(okAction)
        
        dispatch_async(dispatch_get_main_queue()) {
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
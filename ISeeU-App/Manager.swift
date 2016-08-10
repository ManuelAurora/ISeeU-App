//
//  ClientModel.swift
//  ISeeU-App
//
//  Created by Мануэль on 29.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class Manager
{
    var userData      = UserData()
    let appDelegate   = UIApplication.sharedApplication().delegate as! AppDelegate
    let errorHandler  = ErrorHandler()
    let dataStore     = DataStore.sharedInstance()
    
    func loadMainControllers(fb: Bool) {
        
        let tabBarController   = appDelegate.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("MainTabBar") as! UITabBarController
        let navControllers     = tabBarController.viewControllers
        let mapController      = navControllers![0].childViewControllers[0] as! MapViewController
        let studentsController = navControllers![1].childViewControllers[0] as! StudentsTableViewController
        
        mapController.manager      = self
        studentsController.manager = self
        
        let loginController = appDelegate.window!.rootViewController! as! LoginViewController        
       
        if !fb
        {
            if let spinner = loginController.loginButton.viewWithTag(666) as? UIActivityIndicatorView
            {
                spinner.removeFromSuperview()
            }
        }
        
        loginController.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    func refresh(caller caller: UIViewController) {
        requestInfoFor(caller)
        updateMapAndTable()
    }
    
    func requestInfoFor(caller: UIViewController) {
        
        let baseURL = ParseApi.parseApiPath
        let params  = ParseApi.parseParameters
        
        let fullUrl = baseURL + params.stringFromHttpParameters()
        
        RequestHandler.sharedInstance().handleGetTask(fullUrl) { (task, error) -> Void in
            
            guard error == nil else { self.errorHandler.handleError(error!, controller: caller); return }
            
            guard let results = task["results"] as? [[String: AnyObject]] else { return }
            
            self.parseStudents(results)
            
            self.updateMapAndTable()
        }
    }
    
    func updateMapAndTable() {
        
        let tabBarController   = appDelegate.window?.rootViewController?.presentedViewController as! UITabBarController
        let navControllers     = tabBarController.viewControllers
        let mapController      = navControllers![0].childViewControllers[0] as! MapViewController
        let studentsController = navControllers![1].childViewControllers[0] as! StudentsTableViewController
        
        var annotations  = [MKPointAnnotation]()
        
        for student in dataStore.students {
            
            if let latitude = student.latitude, let longitude = student.longitude
            {
                let lat  = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let firstName = student.firstName!
                let lastName  = student.lastName!
                let mediaURL  = student.mediaURL!
                
                let annotation = MKPointAnnotation()
                annotation.title = "\(firstName) \(lastName)"
                annotation.coordinate = coordinate
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
      
            mapController.map.addAnnotations(annotations)
            studentsController.tableView.reloadData()
        }
    }
    
    func addNewPin(caller caller: UIViewController) {
        let controller = appDelegate.window!.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("AddNewPinViewController") as! AddNewPinViewController
        
         caller.presentViewController(controller, animated: true, completion: nil)
    }
    
    func logout(caller caller: UIViewController) {
        appDelegate.window!.rootViewController!.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)
        RequestHandler.sharedInstance().handleDeleteSessionTask(UdacityApi.apiPathToCreateSession)
    }
    
    func parseStudents(results: [[String: AnyObject]]) {
        
        for student in results {
            
            let student = Student(fromDictionary: student)
            
            self.dataStore.students.append(student)
            
        }
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
    
    func handleError(error: NSError?, controller: UIViewController) {
        
        var alertMessage = ""
        
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        if controller is LoginViewController && error!.description.containsString("There is no data") {
            
            let controller = controller as! LoginViewController
            
            alertMessage = "Connection fails"
            
            controller.renewMainMenu()
        }
            
        else if controller is LoginViewController {
            alertMessage = "Wrong E-mail or Password"
            
            let controller = controller as! LoginViewController
            
            controller.renewMainMenu()            
        }
            
        else if controller is MapViewController && error!.description.containsString("There is no data") {
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
    
    func showAlert(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        return alert
        
    }
    
    
}
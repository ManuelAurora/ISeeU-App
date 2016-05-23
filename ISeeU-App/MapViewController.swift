//
//  ViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 20.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{
    var manager = Manager.sharedInstance()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        requestInfo()
        mapView.reloadInputViews()        
    }
    
    @IBAction func addNewPin(sender: UIBarButtonItem) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewPinViewController") as! AddNewPinViewController
                
        presentViewController(controller, animated: true, completion: nil)        
    }
    
    @IBAction func Logout(sender: UIBarButtonItem) {
        manager.appDelegate.window!.rootViewController!.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInfo()
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            
            guard let urlToOpen = view.annotation!.subtitle! else { return }
            
            app.openURL(NSURL(string: urlToOpen)!)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        guard pinView == nil else { pinView?.annotation = annotation; return pinView }
        
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.canShowCallout = true
        pinView?.pinTintColor = UIColor.greenColor()
        pinView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        
        return pinView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard !manager.userData.loggedIn else { return }
        
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window!.rootViewController!.presentViewController(loginController, animated: false, completion: nil)
    }
    
    func requestInfo() {
        
        let baseURL = ParseApi.parseApiPath
        let params  = ParseApi.parseParameters
        
        let fullUrl = baseURL + params.stringFromHttpParameters()
        
        RequestHandler.sharedInstance().handleGetTask(fullUrl) { (task, error) -> Void in
            
            guard error == nil else { self.manager.errorHandler.handleError(error!, controller: self); return }
            
            self.manager.students = task["results"] as! [[String: AnyObject]]
            
            let studentsArray = self.manager.students
            var annotations   = [MKPointAnnotation]()
            
            for person in studentsArray {
                
                let student = Student(fromDictionary: person)
                
                let lat  = CLLocationDegrees(student.latitude!)
                let long = CLLocationDegrees(student.longitude!)
                
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
            
            self.mapView.addAnnotations(annotations)
        }
    }
}


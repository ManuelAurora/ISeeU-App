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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func addNewPin(sender: UIBarButtonItem) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewPinViewController") as! AddNewPinViewController
     
        presentViewController(controller, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
        RequestHandler.sharedInstance().handleGetTask("https://api.parse.com/1/classes/StudentLocation") { (task, error) -> Void in
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).students = task["results"] as! [[String: AnyObject]]
            
            let studentsArray = self.appDelegate.students
            var annotations = [MKPointAnnotation]()
            
            for person in studentsArray {
                
                let student = Student(fromDictionary: person)
                
                let lat = CLLocationDegrees(student.latitude!)
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
        if !(UIApplication.sharedApplication().delegate as! AppDelegate).loggedIn {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        appDelegate.window?.rootViewController?.presentViewController(loginController, animated: false, completion: nil)
        }
    }
    
}


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
        
     //  mapView.setRegion(<#T##region: MKCoordinateRegion##MKCoordinateRegion#>, animated: <#T##Bool#>)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = "{\"udacity\": {\"username\": \"manuel.aurora@yandex.ru\", \"password\": \"luntik11\"}}"
        let url = "https://www.udacity.com/api/session"
        
        
        Request.sharedInstance().handleGetTask("https://api.parse.com/1/classes/StudentLocation") { (task, error) -> Void in
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).students = task["results"] as! [[String: AnyObject]]
            
            let students = self.appDelegate.students
            var annotations = [MKPointAnnotation]()
            
            for student in students {
                let lat = CLLocationDegrees(student["latitude"] as! Double)
                let long = CLLocationDegrees(student["longitude"] as! Double)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let firstName = student["firstName"] as! String
                let lastName  = student["lastName"] as! String
                let mediaURL  = student["mediaURL"] as! String
                
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
    
    
}


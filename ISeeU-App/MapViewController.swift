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
    
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func refresh(sender: UIBarButtonItem) {
         manager.refresh(caller: self)
    }
    
    @IBAction func addNewPin(sender: UIBarButtonItem) {
      
        manager.addNewPin(caller: self)
    }
    
    @IBAction func Logout(sender: UIBarButtonItem) {
        
        manager.logout(caller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestInfoFor(self)       
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            
            guard let urlToOpen = view.annotation!.subtitle! where urlToOpen.containsString("https://") || urlToOpen.containsString("http://") else { return }
            
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
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        guard !manager.userData.loggedIn else { return }
//        
//        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
//        let loginController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        appDelegate.window!.rootViewController!.presentViewController(loginController, animated: false, completion: nil)
//    }
}


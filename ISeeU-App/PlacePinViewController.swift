//
//  PlacePinViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class PlacePinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate
{
    var manager = Manager.sharedInstance()
    
    var coordinateRegion: MKCoordinateRegion?  
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var enterLinkTextField: UITextField!
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitLocation() {
        
        manager.userData.currentUser.mediaURL = enterLinkTextField.text
        
        let userData = manager.userData.currentUser
        
        let jsonBody = "{\"uniqueKey\": \"\(userData.udacityKey)\", \"firstName\": \"\(userData.firstName)\", \"lastName\": \"\(userData.lastName)\",\"mapString\": \"\(userData.location)\", \"mediaURL\": \"\(userData.mediaURL)\",\"latitude\": \(userData.latitude), \"longitude\": \(userData.longitude)}"
        
        RequestHandler.sharedInstance().handlePostTask(ParseApi.parseApiPath, jsonBody: jsonBody) {
            (task, error) -> Void in
            
            guard error == nil else { self.manager.errorHandler.handleError(error!, controller: self); return }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                 self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })            
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let placeHolderText = NSAttributedString(string: "Enter a Link To Share Here", attributes: [NSForegroundColorAttributeName: enterLinkTextField.tintColor])
     
        enterLinkTextField.attributedPlaceholder = placeHolderText
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let coordinate = CLLocationCoordinate2D(latitude: coordinateRegion!.center.latitude, longitude: coordinateRegion!.center.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
        
        mapView.setRegion(coordinateRegion!, animated: true)       

    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        guard pinView == nil else { pinView?.annotation = annotation; return pinView }
        
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.canShowCallout = false
        pinView?.pinTintColor = UIColor.greenColor()       
        
        return pinView
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }    
}

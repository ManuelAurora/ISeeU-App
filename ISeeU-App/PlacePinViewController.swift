//
//  PlacePinViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class PlacePinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    var coordinateRegion: MKCoordinateRegion?  
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var enterLinkTextField: UITextField!
    
    @IBAction func submitLocation() {
        
        let currentStudent = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser
        
        let jsonBody = "{\"uniqueKey\": \"\(currentStudent.udacityKey)\", \"firstName\": \"\(currentStudent.firstName)\", \"lastName\": \"\(currentStudent.lastName)\",\"mapString\": \"\(currentStudent.location)\", \"mediaURL\": \"\(currentStudent.mediaURL)\",\"latitude\": \(currentStudent.latitude), \"longitude\": \(currentStudent.longitude)}"
        
        RequestHandler.sharedInstance().handlePostTask(ParseApi.parseApiPath, jsonBody: jsonBody) {
            (task, error) -> Void in
           print(task)
        }
        
        dismissViewControllerAnimated(false) { () -> Void in
            self.dismissViewControllerAnimated(false, completion: nil)
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

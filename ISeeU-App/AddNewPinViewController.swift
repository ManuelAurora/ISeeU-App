//
//  AddNewPinViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class AddNewPinViewController: UIViewController, UITextFieldDelegate
{
    var manager = Manager.sharedInstance()
    
    @IBOutlet weak var titleLAbel:        UILabel!
    @IBOutlet weak var mapView:           MKMapView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findButton: UIButton!
    
    @IBAction func findOnTheMap() {
        
        activityIndicator.hidden = false
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) {
            (placemarks, error) -> Void in
            
            guard error == nil else { self.manager.errorHandler.handleError(error!, controller: self); return }
            
            let placemark = placemarks?[0]
            
            let regionRadius: CLLocationDistance = 1000
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance((placemark?.location?.coordinate)!, regionRadius * 2.0, regionRadius * 2.0)
            
            self.manager.userData.currentUser.latitude  = Float(coordinateRegion.center.latitude)
            self.manager.userData.currentUser.longitude = Float(coordinateRegion.center.longitude)
            self.manager.userData.currentUser.location  = self.locationTextField.text!
            
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PlacePinViewController") as! PlacePinViewController
                        
            controller.coordinateRegion = coordinateRegion
            
            self.activityIndicator.hidden = true
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
      
        let placeHolderText = NSAttributedString(string: "Enter your location here", attributes: [NSForegroundColorAttributeName: locationTextField.tintColor])
        findButton.layer.cornerRadius = 10
        findButton.clipsToBounds = true
        
        locationTextField.attributedPlaceholder = placeHolderText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }        
}

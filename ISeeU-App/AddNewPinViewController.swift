//
//  AddNewPinViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class AddNewPinViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLAbel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var findButton: UIButton!
    
    @IBAction func findOnTheMap() {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) {
            (placemarks, error) -> Void in
            
            let placemark = placemarks?[0]
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance((placemark?.location?.coordinate)!, regionRadius * 2.0, regionRadius * 2.0)
           
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PlacePinViewController") as! PlacePinViewController
            
            controller.coordinateRegion = coordinateRegion
            
            self.presentViewController(controller, animated: false, completion: nil)
            
        }        
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeHolderText = NSAttributedString(string: "Enter your location here", attributes: [NSForegroundColorAttributeName: locationTextField.tintColor])
        findButton.layer.cornerRadius = 10
        findButton.clipsToBounds = true
        
        locationTextField.attributedPlaceholder = placeHolderText

        // Do any additional setup after loading the view.
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

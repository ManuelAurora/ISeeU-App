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
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let json = "{\"udacity\": {\"username\": \"manuel.aurora@yandex.ru\", \"password\": \"luntik11\"}}"
        let url = "https://www.udacity.com/api/session"
        
        
        Request.sharedInstance().handleGetTask("https://api.parse.com/1/classes/StudentLocation") { (task, error) -> Void in
            
               (UIApplication.sharedApplication().delegate as! AppDelegate).students = task["results"] as! [[String: AnyObject]]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


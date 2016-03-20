//
//  ViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 20.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let json = "{\"udacity\": {\"username\": \"manuel.aurora@yandex.ru\", \"password\": \"luntik11\"}}"
        let url = "https://www.udacity.com/api/session"
        Request.sharedInstance().handlePostTask(url, jsonBody: json) {
            (task, error) -> Void in
            print(task)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


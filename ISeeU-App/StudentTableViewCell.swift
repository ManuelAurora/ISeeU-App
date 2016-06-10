//
//  StudentTableViewCell.swift
//  ISeeU-App
//
//  Created by Мануэль on 20.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import MapKit

class StudentTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var button:           UIButton!
    
    @IBAction func showLocation(sender: UIButton) {
        
        let tabBar        = Manager.sharedInstance().appDelegate.window?.rootViewController?.presentedViewController as! UITabBarController
        let navController = tabBar.viewControllers
        let mapController = navController![0].childViewControllers[0] as! MapViewController
        
        let mapView = mapController.map
        let student = DataStore.sharedInstance().students[button.tag]
        
        let latitude  = student.latitude
        let longitude = student.longitude
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let region     = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        tabBar.selectedIndex = 0
    }
}

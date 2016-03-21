//
//  Student.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

struct Student {
    
    let latitude: Double?
    let longitude: Double?
    let studentId: String?
    let firstName: String?
    let lastName: String?
    let mediaURL: String?
    let udacityKey: String?
    let location: String?
    
    init(fromDictionary dict: [String: AnyObject]) {
        
        latitude   = dict["latitude"]  as? Double
        longitude  = dict["longitude"] as? Double
        studentId  = dict["objectId"]  as? String
        firstName  = dict["firstName"] as? String
        lastName   = dict["lastName"]  as? String
        mediaURL   = dict["mediaURL"]  as? String
        udacityKey = dict["uniqueKey"] as? String
        location   = dict["mapString"] as? String
    }
    
}
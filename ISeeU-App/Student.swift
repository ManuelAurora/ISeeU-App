//
//  Student.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

struct Student {
    
    var latitude: Float!
    var longitude: Float!
    var studentId: String!
    var firstName: String!
    var lastName: String!
    var mediaURL: String!
    var udacityKey: String!
    var location: String!
    
    init() {
        latitude = nil
        longitude = nil
        studentId = nil
        firstName = nil
        lastName = nil
        mediaURL = nil
        udacityKey = nil
        location = nil
    }
    
    init(fromDictionary dict: [String: AnyObject]) {
        
        latitude   = dict["latitude"]  as? Float
        longitude  = dict["longitude"] as? Float
        studentId  = dict["objectId"]  as? String
        firstName  = dict["firstName"] as? String
        lastName   = dict["lastName"]  as? String
        mediaURL   = dict["mediaURL"]  as? String
        udacityKey = dict["uniqueKey"] as? String
        location   = dict["mapString"] as? String
    }
    
}
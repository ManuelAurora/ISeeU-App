//
//  DataStore.swift
//  ISeeU-App
//
//  Created by Мануэль on 10.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

class DataStore
{
    internal lazy var students = [Student]()
    
    class func sharedInstance() -> DataStore {
        
        struct Singleton {
            static let sharedInstance = DataStore()
        }
        
        return Singleton.sharedInstance
        
    }    
    
}
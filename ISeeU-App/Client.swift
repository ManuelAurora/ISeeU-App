//
//  ClientModel.swift
//  ISeeU-App
//
//  Created by Мануэль on 29.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

class Client
{
    var students = [[String: AnyObject]]()
    var userData = UserData()    
}

struct UserData
{
    var currentUser = Student()
    var loggedIn = false
}
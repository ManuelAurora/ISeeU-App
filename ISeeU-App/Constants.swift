//
//  Constants.swift
//  ISeeU-App
//
//  Created by Мануэль on 20.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit

struct ParseApi
{
    static let apiScheme       = "https"
    static let parseAppId      = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let parseAPIKey     = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let parseApiPath    = "https://api.parse.com/1/classes/StudentLocation?"
    static let headerAppId     = "X-Parse-Application-Id"
    static let headerRESTk     = "X-Parse-REST-API-Key"
    static let parseParameters = ["limit": "100", "order": "-updatedAt"]
}

struct UdacityApi
{
    static let apiPathToCreateSession = "https://www.udacity.com/api/session"
}


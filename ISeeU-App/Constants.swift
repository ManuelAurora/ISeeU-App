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
    static let parseApiPath    = "https://parse.udacity.com/parse/classes/StudentLocation?"
    static let headerAppId     = "X-Parse-Application-Id"
    static let headerRESTk     = "X-Parse-REST-API-Key"
    static let parseParameters = ["limit": "100", "order": "-updatedAt"]
}

struct UdacityApi
{
    static let apiPathToCreateSession = "https://www.udacity.com/api/session"
    static let facebookHTTPBody = "{\"facebook_mobile\": {\"access_token\": \"DADFMS4SN9e8BAD6vMs6yWuEcrJlMZChFB0ZB0PCLZBY8FPFYxIPy1WOr402QurYWm7hj1ZCoeoXhAk2tekZBIddkYLAtwQ7PuTPGSERwH1DfZC5XSef3TQy1pyuAPBp5JJ364uFuGw6EDaxPZBIZBLg192U8vL7mZAzYUSJsZA8NxcqQgZCKdK4ZBA2l2ZA6Y1ZBWHifSM0slybL9xJm3ZBbTXSBZCMItjnZBH25irLhIvbxj01QmlKKP3iOnl8Ey;\"}}"
}


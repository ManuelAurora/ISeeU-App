//
//  Utility.swift
//  ISeeU-App
//
//  Created by Мануэль on 23.05.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

extension Dictionary
{
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            
            let percentEscapedKey   = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }
}

extension String
{
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
    }
}

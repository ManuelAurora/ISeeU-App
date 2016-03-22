//
//  RequestHandler.swift
//  ISeeU-App
//
//  Created by Мануэль on 20.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit

class RequestHandler: NSObject
{
    let session = NSURLSession.sharedSession()
    
    override init() {
        super.init()
        
    }
    
    func handlePostTask(url: String, udacity: Bool = false, jsonBody: String, completionHandler: (task: AnyObject!, error: NSError?) -> Void) {
                
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       // request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        //request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
          
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(task: nil, error: NSError(domain: "handlePostTask", code: 1, userInfo: userInfo))
            }
            
            guard data     != nil else { sendError("There is no data"); return }
            guard error    == nil else { sendError("There was an error with request \(error)"); return }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else { sendError("Invalid status code"); return }
            
            self.convertDataWithCompletionHandler(data!, udacity: udacity, completionHandler: completionHandler)
        }
        task.resume()
    }
    
    func handleGetTask(url: String, udacity: Bool = false, completionHandler: (task: AnyObject!, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        //  var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        //  request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        //request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task =  session.dataTaskWithRequest(request) { (data, response, error) -> Void in
        
        self.convertDataWithCompletionHandler(data!, udacity: udacity, completionHandler: completionHandler)
        
        }
        task.resume()
        
    }
    
    
    func urlFromParameters(parameters: [String: AnyObject], withExtenstion: String?) -> NSURL {
        
        let components = NSURLComponents()
        
       // components.path   = Constants.parseAPIPath + (withExtenstion ?? "")
        //components.scheme = Constants.apiScheme
      //  components.host   = Constants.parseAPIHost
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            
            components.queryItems?.append(queryItem)
        }
        print(components.URL!)
        return components.URL!
      
    }

    private func convertDataWithCompletionHandler(data: NSData, udacity: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var newData:    NSData! // Used if we parcing Udacity
        var parsedJson: AnyObject!
        
        do {          
            if udacity { newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) } // SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.            
            parsedJson = try NSJSONSerialization.JSONObjectWithData(udacity ? newData : data , options: .AllowFragments)
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey: "Unable to parse data \(data)"]
            completionHandler(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedJson, error: nil)
    }
    
    class func sharedInstance() -> RequestHandler {
        struct Singleton {
            static let sharedInstance = RequestHandler()
        }
        return Singleton.sharedInstance
    }
 
    
}

//
//  RequestHandler.swift
//  ISeeU-App
//
//  Created by Мануэль on 20.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit

class Request: NSObject
{
    let session = NSURLSession.sharedSession()
    
    override init() {
        super.init()
        
    }
    
    func handlePostTask(url: String, jsonBody: String, completionHandler: (task: AnyObject!, error: NSError?) -> Void) {
                
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
          
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(task: nil, error: NSError(domain: "handlePostTask", code: 1, userInfo: userInfo))
            }
            
            guard data     != nil else { sendError("There is no data"); return }
            guard error    == nil else { sendError("There was an error with request \(error)"); return }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else { sendError("Invalid status code"); return }
            
            self.convertDataWithCompletionHandler(data!, completionHandler: completionHandler)            
        }
        task.resume()
    }
//    
//    func urlFromParameters(parameters: [String: AnyObject], withExtenstion: String?) -> NSURL {
//        
//        let components = NSURLComponents()
//        
//        components.path   = Constants.parseAPIPath + (withExtenstion ?? "")
//        components.scheme = Constants.apiScheme
//        components.host   = Constants.parseAPIHost
//        
//        for (key, value) in parameters {
//            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
//            
//            components.queryItems?.append(queryItem)
//        }
//        print(components.URL!)
//        return components.URL!
//      
//    }
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedJson: AnyObject!
        
        do {
          // TODO: MAKE -5 BUKV
            parsedJson = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Unable to parse data \(data)"]
            completionHandler(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedJson, error: nil)
    }
    
    class func sharedInstance() -> Request {
        struct Singleton {
            static let sharedInstance = Request()
        }
        return Singleton.sharedInstance
    }
 
    
}

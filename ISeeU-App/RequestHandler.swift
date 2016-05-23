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
    let session       = NSURLSession.sharedSession()
    var downloadTasks = [NSURLSessionDataTask]()
    
    override init() {
        super.init()        
    }
    
    func cancel() {
        for task in downloadTasks {
            task.cancel()
        }
    }
    
    func handlePostTask(url: String, udacity: Bool = false, jsonBody: String, completionHandler: (task: AnyObject!, error: NSError?) -> Void) {
                
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch udacity
        {
        case true:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
        case false:
            request.addValue(ParseApi.parseAppId,  forHTTPHeaderField: ParseApi.headerAppId)
            request.addValue(ParseApi.parseAPIKey, forHTTPHeaderField: ParseApi.headerRESTk)
        }
        
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
        downloadTasks.append(task)
        task.resume()
    }
    
    func handleGetTask(url: String, udacity: Bool = false, completionHandler: (task: AnyObject!, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
    
        request.addValue(ParseApi.parseAppId, forHTTPHeaderField:  ParseApi.headerAppId)
        request.addValue(ParseApi.parseAPIKey, forHTTPHeaderField: ParseApi.headerRESTk)
        print(request)
        
        let task =  session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            guard error == nil else {
                
                let delegate   = UIApplication.sharedApplication().delegate as! AppDelegate
                let controller = delegate.window!.rootViewController        as! LoginViewController
                let tabbar = controller.presentedViewController             as! UITabBarController
                
                let map = tabbar.childViewControllers[0].childViewControllers[0] as? MapViewController
                
                Manager.sharedInstance().errorHandler.handleError(error!, controller: map!); return
            }
       
            self.convertDataWithCompletionHandler(data!, udacity: udacity, completionHandler: completionHandler)
        }
        
        downloadTasks.append(task)
        task.resume()        
    }
    
    
    func urlFromParameters(parameters: [String: AnyObject], withExtenstion: String?) -> NSURL {
        
        let components = NSURLComponents()
        
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

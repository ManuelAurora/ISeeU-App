//
//  LoginViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate
{
    
    var client: Client!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func login() {
        
        //let authorizationJson  = "{\"udacity\": {\"username\": \"\(emailTextField!.text!)\", \"password\": \"\(passwordTextField!.text!)\"}}"
        
        let parameters = [
            "udacity": [
                "username": emailTextField!.text!,
                "password": passwordTextField!.text!
            ]
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept"      : "application/json"
        ]
        
        var currentUser        = client.userData.currentUser
        
        Alamofire.request(.POST, UdacityApi.apiPathToCreateSession, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
            (response) in
            
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(3903878747)")!)
            request.HTTPMethod = "GET"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            Alamofire.request(request).responseJSON(completionHandler: {
                (response) in
                
                RequestHandler.sharedInstance().convertDataWithCompletionHandler(response.data!, udacity: true, completionHandler: {
                    (result, error) in
                    
                    currentUser.firstName = (result["user"] as! [String: AnyObject])["nickname"] as! String
                    
                    
                    self.dismissViewControllerAnimated(false, completion: nil)
                })
                
            })
        }
    }
    
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        switch udacity {
    //        case true:
    //            request.addValue("application/json", forHTTPHeaderField: "Accept")
    //        case false:
    //            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    //            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    //        }
    
    
    
    //        RequestHandler.sharedInstance().handlePostTask(UdacityApi.apiPathToCreateSession, udacity: true, jsonBody: authorizationJson) { (task, error) -> Void in
    //            guard let data = task as? [String: AnyObject] else { print("failed"); return }
    //            guard error == nil else { print(error); return }
    //
    //            // let sessionInfo = data["session"] as? [String: AnyObject]
    //            let accountInfo = data["account"] as? [String: AnyObject]
    //
    //            currentUser.udacityKey   = accountInfo!["key"] as? String
    //            currentUser.studentId    = accountInfo!["id"]  as? String
    //
    //            self.client.userData.loggedIn = true
    //
    //
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingUserName = UIView(frame: CGRectMake(0, 0, 15, emailTextField.frame.size.height))
        let paddingUserPass = UIView(frame: CGRectMake(0, 0, 15, emailTextField.frame.size.height))
        
        emailTextField.leftView = paddingUserName
        emailTextField.leftViewMode = UITextFieldViewMode .Always
        
        passwordTextField.leftView = paddingUserPass
        passwordTextField.leftViewMode = UITextFieldViewMode .Always
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let placeHolderTextUser = NSAttributedString(string: "Your Username", attributes: [NSForegroundColorAttributeName: emailTextField.tintColor])
        let placeHolderTextPass = NSAttributedString(string: "Your Password", attributes: [NSForegroundColorAttributeName: passwordTextField.tintColor])
        
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        
        emailTextField.attributedPlaceholder = placeHolderTextUser
        passwordTextField.attributedPlaceholder = placeHolderTextPass
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

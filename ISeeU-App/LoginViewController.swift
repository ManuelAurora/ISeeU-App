//
//  LoginViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
    
    var client: Client!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func login() {
        
        let authorizationJson  = "{\"udacity\": {\"username\": \"manuel.aurora@yandex.ru\", \"password\": \"luntik11\"}}"
        var currentUser        = client.userData.currentUser       
        
        RequestHandler.sharedInstance().handlePostTask(UdacityApi.apiPathToCreateSession, udacity: true, jsonBody: authorizationJson) { (task, error) -> Void in
            
            guard error == nil else { self.client.handleError(error!, controller: self); return }
            guard let data = task as? [String: AnyObject] else { print("failed"); return }
            
            let accountInfo = data["account"] as? [String: AnyObject]
            
            currentUser.udacityKey   = accountInfo!["key"] as? String
            currentUser.studentId    = accountInfo!["id"]  as? String
           
            self.client.userData.loggedIn = true
            
            RequestHandler.sharedInstance().handleGetTask("https://www.udacity.com/api/users/\(3903878747)", udacity: true, completionHandler: {
                (task, error) -> Void in
                
                let user = task["user"] as! [String: AnyObject]
                
               currentUser.firstName = user["nickname"] as! String
               
            })
            
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
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

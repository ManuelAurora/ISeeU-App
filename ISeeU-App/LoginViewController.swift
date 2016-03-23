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
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func login() {
        
        let authorizationJson  = "{\"udacity\": {\"username\": \"\(emailTextField!.text!)\", \"password\": \"\(passwordTextField!.text!)\"}}"
        let currentUser = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser
       
        
        RequestHandler.sharedInstance().handlePostTask(UdacityApi.apiPathToCreateSession, udacity: true, jsonBody: authorizationJson) { (task, error) -> Void in
            guard let data = task as? [String: AnyObject] else { print("failed"); return }
            guard error == nil else { print(error); return }
            
            let sessionInfo = data["session"] as? [String: AnyObject]
            let accountInfo = data["account"] as? [String: AnyObject]
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser.udacityKey = accountInfo!["key"] as? String
            (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser.studentId = sessionInfo!["id"] as? String
            (UIApplication.sharedApplication().delegate as! AppDelegate).loggedIn = true
            
            RequestHandler.sharedInstance().handleGetTask("https://www.udacity.com/api/users/\(3903878747)", udacity: true, completionHandler: {
                (task, error) -> Void in
                let user = task["user"] as! [String: AnyObject]
               (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser.firstName = user["nickname"] as! String
               
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

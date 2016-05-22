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
    
    var client = Client()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func login() {
        
        guard loginButton.titleLabel!.text != "Cancel" else { loginButton.viewWithTag(666)!.removeFromSuperview(); changeTitle("Log In"); RequestHandler.sharedInstance().cancel();  return }
        
        let actInd = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        
        view.addSubview(actInd)
        
        actInd.center = CGPointMake(loginButton.frame.size.width - actInd.frame.width, loginButton.frame.size.height / 2)
        actInd.tag    = 666
        
        loginButton.addSubview(actInd)
        
        actInd.startAnimating()
        
        changeTitle("Cancel")
        
        let authorizationJson  = "{\"udacity\": {\"username\": \"manuel.aurora@yandex.ru\", \"password\": \"luntik11\"}}"
                
        RequestHandler.sharedInstance().handlePostTask(UdacityApi.apiPathToCreateSession, udacity: true, jsonBody: authorizationJson) { (task, error) -> Void in
            
            guard error == nil else { self.client.handleError(error!, controller: self); return }
            guard let data = task as? [String: AnyObject] else { print("failed"); return }
            
            let accountInfo = data["account"] as? [String: AnyObject]
            let sessionInfo = data["session"] as? [String: AnyObject]
            
            let key = accountInfo!["key"] as? String
            let id  = sessionInfo!["id"]  as? String
            
            self.client.userData.currentUser.udacityKey = key!
            self.client.userData.currentUser.studentId  = id!
           
            self.client.userData.loggedIn = true
            
            RequestHandler.sharedInstance().handleGetTask("https://www.udacity.com/api/users/\(key!)", udacity: true, completionHandler: {
                (task, error) -> Void in
                
                let user = task["user"] as! [String: AnyObject]
                
                self.client.userData.currentUser.firstName = user["nickname"]  as! String
                self.client.userData.currentUser.lastName  = user["last_name"] as! String
                
                dispatch_sync(dispatch_get_main_queue(), { 
                    self.changeTitle("Log In")
                })
                
                self.client.loadMainControllers()                
            })
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
    
    func changeTitle(title: String) {
        loginButton.setTitle(title, forState: .Normal)
    }
}

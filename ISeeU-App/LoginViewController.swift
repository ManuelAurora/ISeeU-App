//
//  LoginViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 21.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate
{
    
    let manager = Manager.sharedInstance()
    let loginManager = FBSDKLoginManager()
    
    var sessionCreated: Bool = false
       
    @IBOutlet weak var loginButton:       UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField:    UITextField!
        
    @IBAction func login() {
        
        guard loginButton.titleLabel!.text != "Cancel" else { renewMainMenu(); return }
        
        let actInd = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        
        view.addSubview(actInd)
        
        actInd.center = CGPointMake(loginButton.frame.size.width - actInd.frame.width, loginButton.frame.size.height / 2)
        actInd.tag    = 666
        
        loginButton.addSubview(actInd)
        
        actInd.startAnimating()
        
        changeTitle("Cancel")
        
        let authorizationJson  = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}"
                
        RequestHandler.sharedInstance().handlePostTask(UdacityApi.apiPathToCreateSession, udacity: true, jsonBody: authorizationJson) { (task, error) -> Void in
            
            guard error == nil else { self.manager.errorHandler.handleError(error, controller: self); return }
            guard let data = task as? [String: AnyObject] else { print("failed"); return }
         
            let accountInfo = data["account"] as? [String: AnyObject]
            let sessionInfo = data["session"] as? [String: AnyObject]
            
            let key = accountInfo!["key"] as? String
            let id  = sessionInfo!["id"]  as? String
            
            self.manager.userData.currentUser.udacityKey = key!
            self.manager.userData.currentUser.studentId  = id!
           
            self.manager.userData.loggedIn = true
            
            self.sessionCreated = true
                        
            RequestHandler.sharedInstance().handleGetTask("https://www.udacity.com/api/users/\(key!)", udacity: true, completionHandler: {
                (task, error) -> Void in
                
                let user = task["user"] as! [String: AnyObject]
                
                self.manager.userData.currentUser.firstName = user["nickname"]  as! String
                self.manager.userData.currentUser.lastName  = user["last_name"] as! String
                
                if self.sessionCreated
                {
                    dispatch_sync(dispatch_get_main_queue(), {
                        
                        self.changeTitle("Log In")
                        
                        self.manager.loadMainControllers(false)
                        
                    })
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
       
        createFBButton()
        
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
    
    func renewMainMenu() {
        dispatch_async(dispatch_get_main_queue()) {
            
         if let spinner = self.loginButton.viewWithTag(666)
         {
            spinner.removeFromSuperview()
         }
            self.changeTitle("Log In")
            RequestHandler.sharedInstance().cancel()
        }    
    }
    
    func createFBButton() {
        
        let loginButton = FBSDKLoginButton()
        
        loginButton.delegate = self
        loginButton.center.x = self.view.center.x
        loginButton.center.y = view.frame.height - (loginButton.frame.height * 2)
        view.addSubview(loginButton)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        loginManager.logOut()
        manager.loadMainControllers(true)
    }
 
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //Not decided yet :3
    }
}

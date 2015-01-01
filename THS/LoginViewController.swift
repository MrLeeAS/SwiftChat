//
//  LoginViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var usernameField: UITextField?
    var passwordField: UITextField?
    var loginButton: UIButton?
    var signupButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.greenColor()

        usernameField = UITextField(frame: CGRectMake(10, 50, view.frame.size.width-20, 50))
        usernameField?.placeholder = "Username"
        view.addSubview(usernameField!)

        passwordField = UITextField(frame: CGRectMake(10, 100, view.frame.size.width-20, 50))
        passwordField?.placeholder = "Password"
        view.addSubview(passwordField!)

        loginButton = UIButton(frame: CGRectMake(10, 150, view.frame.size.width-20, 50))
        loginButton?.setTitle("Log In", forState: UIControlState.Normal)
        loginButton?.addTarget(self, action: "signIn", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton!)

        signupButton = UIButton(frame: CGRectMake(10, 200, view.frame.size.width-20, 50))
        signupButton?.setTitle("Sign Up", forState: UIControlState.Normal)
        signupButton?.addTarget(self, action: "signUp", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(signupButton!)
    }

    func signIn() {
        PFUser.logInWithUsernameInBackground(usernameField?.text, password: passwordField?.text) { (user: PFUser!, error: NSError!) -> Void in
            if error == nil {
                self.presentViewController(TabBarController(), animated: false, completion: nil)
            } else {
                UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }

    func signUp() {
        presentViewController(SignUpViewController(), animated: false, completion: nil)
    }
}

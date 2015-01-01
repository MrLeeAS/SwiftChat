//
//  SignUpViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    var signupButton: UIButton?
    var usernameField: UITextField?
    var passwordField: UITextField?
    var emailField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blueColor()

        usernameField = UITextField(frame: CGRectMake(10, 50, view.frame.size.width-20, 50))
        usernameField?.placeholder = "Username"
        view.addSubview(usernameField!)

        passwordField = UITextField(frame: CGRectMake(10, 100, view.frame.size.width-20, 50))
        passwordField?.placeholder = "Password"
        view.addSubview(passwordField!)

        emailField = UITextField(frame: CGRectMake(10, 150, view.frame.size.width-20, 50))
        emailField?.placeholder = "Email"
        view.addSubview(emailField!)

        signupButton = UIButton(frame: CGRectMake(10, 200, view.frame.size.width-20, 50))
        signupButton?.setTitle("Sign Up", forState: UIControlState.Normal)
        signupButton?.addTarget(self, action: "signedUp", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(signupButton!)
    }

    func signedUp() {
        var newUser = PFUser()
        newUser.username = usernameField?.text
        newUser.password = passwordField?.text
        newUser.email = emailField?.text
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error == nil {
                self.presentViewController(TabBarController(), animated: false, completion: nil)
            } else {
                UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
}

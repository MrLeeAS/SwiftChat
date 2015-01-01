//
//  LoginViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        signIn()
        //create button for login
        //create button for signup
    }

    func signIn() {
        presentViewController(TabBarController(), animated: true, completion: nil)
    }

    func signUp() {
        presentViewController(SignUpViewController(), animated: true, completion: nil)
    }
}

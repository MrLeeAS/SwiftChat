//
//  SignUpViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        signedUp()
        //create button for signup
    }

    func signedUp() {
        presentViewController(TabBarController(), animated: true, completion: nil)
    }
}

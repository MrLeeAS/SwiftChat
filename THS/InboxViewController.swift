//
//  InboxViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logoutButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.Plain, target: self, action: "signOut")
        navigationItem.rightBarButtonItem = logoutButton
    }

    func signOut() {
        PFUser.logOut()
        view.window?.rootViewController = LoginViewController()
//        presentViewController(LoginViewController(), animated: false, completion: nil)
    }
}

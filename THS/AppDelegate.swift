//
//  AppDelegate.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("N42cx5AWNrd0NahFqEU764OWF2y07TCYZ4p3YnuT", clientKey: "scBBRBU38kBTxzPM0OM0lWjY2uo7CJ3DRD6efjqB")

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController = vc()
        self.window?.makeKeyAndVisible()
        return true
    }

    func vc() -> UIViewController {
        return PFUser.currentUser() != nil ? TabBarController() : LoginViewController()
    }
}


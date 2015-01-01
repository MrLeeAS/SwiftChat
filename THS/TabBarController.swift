//
//  TabBarController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var inbox = InboxViewController()
        inbox.title = "Inbox"
        var inboxNV = UINavigationController(rootViewController: inbox)
        var friends = FriendsViewController()
        friends.title = "Friends"
        var friendsNV = UINavigationController(rootViewController: friends)
        var camera = CameraViewController()
        camera.title = "Camera"
        var cameraNV = UINavigationController(rootViewController: camera)

        viewControllers = [inboxNV, friendsNV, cameraNV]

    }
}

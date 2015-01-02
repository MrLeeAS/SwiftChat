//
//  InboxViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    var friends: Array<AnyObject>?

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = []

        let logoutButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.Plain, target: self, action: "signOut")
        navigationItem.rightBarButtonItem = logoutButton

        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }

    func signOut() {
        PFUser.logOut()
        view.window?.rootViewController = LoginViewController()
//        presentViewController(LoginViewController(), animated: false, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: NSString = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        let user = friends![indexPath.row] as PFUser
        cell?.textLabel?.text = user.username
        return cell!
    }
}

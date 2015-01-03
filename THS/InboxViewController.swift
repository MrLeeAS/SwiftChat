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
    var messages: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        messages = []

        let logoutButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.Plain, target: self, action: "signOut")
        navigationItem.rightBarButtonItem = logoutButton

        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let query = PFQuery(className: "Messages")
        query.whereKey("recipientIds", equalTo: PFUser.currentUser().objectId)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.messages = objects
                self.tableView?.reloadData()
            } else {
                println(error)
            }
        }
    }

    func signOut() {
        PFUser.logOut()
        view.window?.rootViewController = LoginViewController()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: NSString = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        let message = messages![indexPath.row] as PFObject
        cell?.textLabel?.text = message["senderName"] as NSString
        let fileType = message["fileType"] as NSString
        cell?.imageView?.image = UIImage(named: fileType == "image" ? "icon_image" : "icon_video")
        return cell!
    }
}

//
//  FriendsViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    var friendsRelation: PFRelation?
    var friends: Array<AnyObject>?

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = []

        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "edit")
        navigationItem.rightBarButtonItem = editButton

        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        friendsRelation = PFUser.currentUser().relationForKey("friendsRelation")
        var query = friendsRelation?.query()
        query?.orderByAscending("username")
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.friends = objects
                self.tableView?.reloadData()
            } else {
                println(error.localizedDescription)
            }
        })
    }

    func edit() {
        var editVC = EditFriendsViewController()
        editVC.friends = friends
        navigationController?.pushViewController(editVC, animated: true)
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

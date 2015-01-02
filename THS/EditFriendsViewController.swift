//
//  EditFriendsViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 1/1/15.
//  Copyright (c) 2015 SapanBhuta. All rights reserved.
//

import UIKit

class EditFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    var friends: Array<AnyObject>?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Friends"
        friends = []

        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)

        var query = PFUser.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.friends = objects
                self.tableView?.reloadData()
            } else {
                println(error.localizedDescription)
            }
        }
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        var friendsRelation = PFUser.currentUser().relationForKey("friendsRelation")
        friendsRelation.addObject(friends![indexPath.row] as PFUser)
        PFUser.currentUser().saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error != nil {
                println(error.localizedDescription)
            }
        }
    }
}

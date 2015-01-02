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
    var allUsers: Array<AnyObject>?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Friends"
        allUsers = []

        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var query = PFUser.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.allUsers = objects
                self.tableView?.reloadData()
            } else {
                println(error.localizedDescription)
            }
        }
    }

    func isFriend(user: PFUser) -> Bool {
        return (friends! as Array<PFUser>).filter({ (friend: PFUser) -> Bool in friend.objectId == user.objectId}).count > 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId: NSString = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        let user = allUsers![indexPath.row] as PFUser
        cell?.textLabel?.text = user.username
        cell?.accessoryType = isFriend(user) ? .Checkmark : .None
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var cell = tableView.cellForRowAtIndexPath(indexPath)

        let user = allUsers![indexPath.row] as PFUser
        var friendsRelation = PFUser.currentUser().relationForKey("friendsRelation")

        if isFriend(user) {
            cell?.accessoryType = UITableViewCellAccessoryType.None
            for (var i=0; i<friends!.count; i++) {
                if user.objectId == friends![i].objectId {
                    friends?.removeAtIndex(i)
                    break
                }
            }
            friendsRelation.removeObject(user)
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            friends?.append(user)
            friendsRelation.addObject(user)
        }

        PFUser.currentUser().saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error != nil {
                println(error.localizedDescription)
            }
        }
    }
}

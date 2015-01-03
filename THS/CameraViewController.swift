//
//  CameraViewController.swift
//  THS
//
//  Created by Sapan Bhuta on 12/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var tableView: UITableView?
    var friends: Array<AnyObject>?
    var recipients: NSMutableArray?
    var imagePicker: UIImagePickerController?
    var image: UIImage?
    var videoFilePath: NSString?
    var picked: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = []
        recipients = []

        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButton

        let sendButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "send")
        navigationItem.rightBarButtonItem = sendButton

        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let friendsRelation = PFUser.currentUser().relationForKey("friendsRelation")
        let query = friendsRelation?.query()
        query?.orderByAscending("username")
        query?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.friends = objects
                self.tableView?.reloadData()
            } else {
                println(error.localizedDescription)
            }
        })

        if picked == nil || !picked! {
            imagePicker = UIImagePickerController()
            imagePicker?.delegate = self
            imagePicker?.allowsEditing = false
            imagePicker?.videoMaximumDuration = 10
            imagePicker?.sourceType = UIImagePickerController.isSourceTypeAvailable(.Camera) ? .Camera : .PhotoLibrary
            imagePicker?.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(imagePicker!.sourceType)!
            presentViewController(imagePicker!, animated: false, completion: nil)
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
        cell?.accessoryType = recipients!.containsObject(user) ? .Checkmark : .None
        cell?.textLabel?.text = user.username
        return cell!
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(false, completion: nil)
        tabBarController?.selectedIndex = 0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        let user = friends![indexPath.row] as PFUser
        if cell!.accessoryType == .None {
            cell?.accessoryType = .Checkmark
            recipients?.addObject(user.objectId)
        }
        else {
            cell?.accessoryType = .None
            recipients?.removeObject(user.objectId)
        }
        println(recipients!)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picked = true
        let mediaType = info["UIImagePickerControllerMediaType"] as? NSString

        if mediaType != nil && mediaType! == kUTTypeImage {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
            if imagePicker!.sourceType == UIImagePickerControllerSourceType.Camera {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        } else {
            videoFilePath = info[UIImagePickerControllerMediaURL]?.path
            if imagePicker!.sourceType == UIImagePickerControllerSourceType.Camera {
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoFilePath) {
                    UISaveVideoAtPathToSavedPhotosAlbum(videoFilePath, nil, nil, nil)
                }
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    func cancel() {
        reset()
    }

    func send() {
        if image == nil && videoFilePath == nil {
            UIAlertView(title: "Try Again", message: "Pick a photo or video", delegate: nil, cancelButtonTitle: "OK").show()
            presentViewController(imagePicker!, animated: false, completion: nil)
        } else {
            uploadMessage()
        }
    }

    func reset() {
        image = nil
        videoFilePath = nil
        recipients?.removeAllObjects()
        picked = false
        tabBarController?.selectedIndex = 0
    }

    func uploadMessage() {
        var fileData: NSData?
        var fileName: NSString?
        var fileType: NSString?

        if image != nil {
            let newImage = resizeImage(image!, width: view.window!.frame.size.width, height: view.window!.frame.size.height)
            fileData = UIImagePNGRepresentation(newImage)
            fileName = "image.png"
            fileType = "image"
        } else {
            fileData = NSData.dataWithContentsOfMappedFile(videoFilePath!) as? NSData
            fileName = "video.mov"
            fileType = "video"
        }

        let file = PFFile(name: fileName, data: fileData, contentType: fileType)
        file.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error == nil {
                let message = PFObject(className: "Messages")
                message.setObject(file, forKey: "file")
                message.setObject(fileType, forKey: "fileType")
                message.setObject(self.recipients!, forKey: "recipientIds")
                message.setObject(PFUser.currentUser().objectId, forKey: "senderId")
                message.setObject(PFUser.currentUser().username, forKey: "senderName")
                message.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                    if error == nil {
                        //worked!
                        self.reset()
                    } else {
                        UIAlertView(title: "Error", message: "Try agian", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                })
            } else {
                UIAlertView(title: "Error", message: "Try agian", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }

    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSizeMake(width, height)
        let rect = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

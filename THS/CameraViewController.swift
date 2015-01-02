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
    var imagePicker: UIImagePickerController?
    var image: UIImage?
    var videoFilePath: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = []

        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = false
        imagePicker?.videoMaximumDuration = 10
        imagePicker?.sourceType = UIImagePickerController.isSourceTypeAvailable(.Camera) ? .Camera : .PhotoLibrary
        imagePicker?.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(imagePicker!.sourceType)!
        presentViewController(imagePicker!, animated: false, completion: nil)
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

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(false, completion: nil)
        tabBarController?.selectedIndex = 0
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info["mediaType"] as NSString
        if mediaType  == kUTTypeImage {
            image? = info[UIImagePickerControllerOriginalImage] as UIImage
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
}

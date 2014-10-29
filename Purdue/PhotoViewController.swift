//
//  PhotoViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class PhotoViewController: UITableViewController, MWPhotoBrowserDelegate {
    var loading: Bool = true
    let photosArray: NSMutableArray = NSMutableArray()
    let displayPhotos: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(white: 0.85, alpha: 0.5)
        self.tableView.rowHeight = 70
        self.navigationItem.title = NSLocalizedString("PHOTOS", comment: "")
        
        let photoData: NSData = NSData(contentsOfURL: NSURL(string: "http://purdue.photoshelter.com/gallery-list/?feed=json"))
        if (photoData != NSNull()) {
            var error: NSError?
            let photoDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(photoData, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
            for photoDetails: NSDictionary in photoDict["clcGal"] as [NSDictionary] {
                if (photoDetails["A_MODE"] as String == "PUB") {
                    let photo = Photo()
                    photo.imageId = photoDetails["I_ID"] as String
                    photo.galleryId = photoDetails["G_ID"] as String
                    photo.name = photoDetails["G_NAME"] as String
                    photo.numImages = (photoDetails["NUM_IMAGES"] as String).toInt()!
                    photo.setTime(photoDetails["G_MTIME"] as String)
                    photosArray.addObject(photo)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return photosArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        let kPhotoTag: Int = 101
        let kTitleTag: Int = 102
        let kDetailTag: Int = 103
        let kRightTag: Int = 104
        
        let photo = photosArray[indexPath.row] as Photo

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            
            let photoView: AsyncImageView = AsyncImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width*3/10, self.tableView.rowHeight))
            photoView.tag = kPhotoTag
            cell?.contentView.addSubview(photoView)
            
            let titleLabel: UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width*3/10+15, 10, UIScreen.mainScreen().bounds.width*7/10-15, 30))
            titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 19)
            titleLabel.tag = kTitleTag
            cell?.contentView.addSubview(titleLabel)
            
            let detailLabel: UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width*3/10+15, 40, UIScreen.mainScreen().bounds.width*7/10-15, 25))
            detailLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
            detailLabel.tag = kDetailTag
            cell?.contentView.addSubview(detailLabel)
            
            let rightView: UIImageView = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.width-30, self.tableView.rowHeight-30, 20, 20))
            rightView.image = UIImage(named: "ToRight").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            rightView.tintColor = UIColor(white: 0.5, alpha: 0.5)
            rightView.tag = 104
            cell?.contentView.addSubview(rightView)
        }
        
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        } else {
            cell?.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        }
        
        (cell?.contentView.viewWithTag(kPhotoTag) as AsyncImageView).imageURL = NSURL(string: "http://cdn.c.photoshelter.com/img-get/\(photo.imageId)/t/200/\(photo.imageId).jpg")
        (cell?.contentView.viewWithTag(kTitleTag) as UILabel).text = photo.name
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        (cell?.contentView.viewWithTag(kDetailTag) as UILabel).text = "\(formatter.stringFromDate(photo.time))  |  \(photo.numImages) Photos"
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.center = CGPointMake(UIScreen.mainScreen().bounds.width-20, self.tableView.rowHeight-20)
        spinner.hidesWhenStopped = true
        (tableView.cellForRowAtIndexPath(indexPath)?.contentView.viewWithTag(104) as UIImageView).alpha = 0
        tableView.cellForRowAtIndexPath(indexPath)?.contentView.addSubview(spinner)
        spinner.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var err: NSError?
            let photo = self.photosArray[indexPath.row] as Photo
            let data: NSData = NSData(contentsOfURL: NSURL(string: "http://purdue.photoshelter.com/gallery/\(photo.galleryId)/?feed=json"))
            let dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSDictionary
            self.displayPhotos.removeAllObjects()
            for imageDict: NSDictionary in dict["images"] as [NSDictionary] {
                let url: NSString = imageDict["src"] as NSString
                let photo: MWPhoto = MWPhoto(URL: NSURL(string: url))
                self.displayPhotos.addObject(photo)
            }
            
            let browser = MWPhotoBrowser(delegate: self)
            browser.displayNavArrows = true
            browser.zoomPhotosToFill = true
            browser.startOnGrid = true
            dispatch_async(dispatch_get_main_queue(), {
                (tableView.cellForRowAtIndexPath(indexPath)?.contentView.viewWithTag(104) as UIImageView).alpha = 1
                spinner.stopAnimating()
                self.presentViewController(UINavigationController(rootViewController: browser), animated: true, completion: nil)
            })
        })
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.displayPhotos.count);
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(self.displayPhotos.count) {
            return self.displayPhotos[Int(index)] as MWPhotoProtocol
        }
        return nil
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, thumbPhotoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(self.displayPhotos.count) {
            return self.displayPhotos[Int(index)] as MWPhotoProtocol
        }
        return nil
    }

}

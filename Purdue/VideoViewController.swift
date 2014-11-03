//
//  VideoViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class VideoViewController: UITableViewController {
    
    let videos: NSMutableArray = NSMutableArray()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Videos"
        self.tableView.rowHeight = 90;
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var err: NSError?
            let data = NSData(contentsOfURL: NSURL(string: "http://gdata.youtube.com/feeds/api/users/PurdueUniversity/uploads?alt=json")!)
            let dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSDictionary
            for entryDict in (dict["feed"] as NSDictionary)["entry"] as [NSDictionary] {
                let title: String = (entryDict["title"] as Dictionary)["$t"]!
                
                let totalSeconds: Int = (((entryDict["media$group"] as NSDictionary)["media$content"] as NSArray)[0])["duration"] as Int
                let duration: String = NSString(format: "%d:%02d", totalSeconds / 60, totalSeconds % 60)
                
                let urlStr: String = (((entryDict["media$group"] as NSDictionary)["media$player"] as NSArray)[0])["url"] as String!
                let url: NSURL = NSURL(string: urlStr)!
                
                let thumbnailUrl: NSURL = NSURL(string: (((entryDict["media$group"] as NSDictionary)["media$thumbnail"] as NSArray)[0])["url"] as String)!
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                let uploadTime: NSDate = dateFormatter.dateFromString((entryDict["published"] as NSDictionary)["$t"] as String)!
                
                let views: String = (entryDict["yt$statistics"] as Dictionary)["viewCount"]! + " views"
                
                let video = Video(title: title, duration: duration, url: url, thumbnailUrl: thumbnailUrl, uploadTime: uploadTime, views: views)
                self.videos.addObject(video)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        let kVideoTag = 101
        let kDurationTag = 102
        let kTitleTag = 103
        let kDateTag = 104
        let kViewTag = 105
        
        let video = videos[indexPath.row] as Video

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            
            let thumbnailIV = UIImageView(frame: CGRectMake(15, 10, 130, 70))
            thumbnailIV.contentMode = UIViewContentMode.ScaleAspectFill
            thumbnailIV.clipsToBounds = true
            thumbnailIV.tag = kVideoTag
            cell?.contentView.addSubview(thumbnailIV)
            
            let durationLbl = UILabel(frame: CGRectZero)
            durationLbl.text = video.duration
            durationLbl.backgroundColor = UIColor.blackColor()
            durationLbl.textColor = UIColor.whiteColor()
            durationLbl.textAlignment = NSTextAlignment.Center
            durationLbl.font = UIFont(name: "Avenir-Heavy", size: 15)
            durationLbl.sizeToFit()
            durationLbl.tag = kDurationTag
            durationLbl.frame = CGRectMake(145 - durationLbl.frame.width - 10 - 5, 80 - durationLbl.frame.height - 5, durationLbl.frame.width + 10, durationLbl.frame.height)
            cell?.contentView.addSubview(durationLbl)
            
            let titleLbl = UILabel(frame: CGRectMake(155, 10, UIScreen.mainScreen().bounds.width - 155 - 10, 40))
            titleLbl.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            titleLbl.numberOfLines = 2
            titleLbl.tag = kTitleTag
            cell?.contentView.addSubview(titleLbl)
            
            let dateLbl = UILabel(frame: CGRectMake(155, 50, UIScreen.mainScreen().bounds.width - 155 - 10, 15))
            dateLbl.font = UIFont(name: "HelveticaNeue", size: 14)
            dateLbl.textColor = UIColor.grayColor()
            dateLbl.tag = kDateTag
            cell?.contentView.addSubview(dateLbl)
            
            let viewLbl = UILabel(frame: CGRectMake(155, 65, UIScreen.mainScreen().bounds.width - 155 - 10, 15))
            viewLbl.font = UIFont(name: "HelveticaNeue", size: 14)
            viewLbl.textColor = UIColor.grayColor()
            viewLbl.tag = kViewTag
            cell?.contentView.addSubview(viewLbl)
            
            let rightView: UIImageView = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.width-35, self.tableView.rowHeight-35, 20, 20))
            rightView.image = UIImage(named: "ToRight")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            rightView.tintColor = UIColor(white: 0.5, alpha: 0.5)
            cell?.contentView.addSubview(rightView)
        }
        
        (cell?.contentView.viewWithTag(kVideoTag) as UIImageView).imageURL = video.thumbnailUrl
        (cell?.contentView.viewWithTag(kDurationTag) as UILabel).text = video.duration
        (cell?.contentView.viewWithTag(kTitleTag) as UILabel).text = video.title!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        (cell?.contentView.viewWithTag(kDateTag) as UILabel).text = dateFormatter.stringFromDate(video.uploadTime!)
        (cell?.contentView.viewWithTag(kViewTag) as UILabel).text = video.views

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = VideoDetailViewController()
        viewController.selectedVideo = videos[indexPath.row] as? Video
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self, action: "goBack")
        viewController.navigationItem.leftBarButtonItem?.tintColor = UIColor(white: 0.3, alpha: 1.0)
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

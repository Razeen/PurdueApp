//
//  BlackboardCourseViewController.swift
//  Purdue
//
//  Created by George Lo on 12/5/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class BBCourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var mapItems: [NSDictionary] = []
    var courseId: NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        for mapItem in mapItems {
            if mapItem["linktype"] as String! == "DIVIDER" {
                mapItems.removeAtIndex(find(mapItems, mapItem)!)
            }
        }
        
        let tableView = UITableView(frame: CGRectZero)
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        self.view = tableView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kImageViewId = 101
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            
            let itemSize: CGSize = CGSizeMake(25, 1)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale)
            let imageRect: CGRect = CGRectMake(0, 0, itemSize.width, itemSize.height)
            cell?.imageView?.image?.drawInRect(imageRect)
            cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let imageView: UIImageView = UIImageView(frame: CGRectMake(15, 17.5, 25, 25))
            imageView.tag = kImageViewId
            imageView.tintColor = ColorUtils.Cool.DarkBlue
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            cell?.contentView.addSubview(imageView)
        }
        
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        cell?.textLabel?.text = mapItems[indexPath.row]["name"] as String!
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let linktype = mapItems[indexPath.row]["linktype"] as String
        if linktype == "CONTENT" || linktype == "resource/x-bb-folder" {
            (cell?.contentView.viewWithTag(kImageViewId) as UIImageView).image = UIImage(named: "Folder")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        } else if linktype == "student_gradebook" {
            (cell?.contentView.viewWithTag(kImageViewId) as UIImageView).image = UIImage(named: "Grades")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        } else if linktype == "discussion_board" {
            (cell?.contentView.viewWithTag(kImageViewId) as UIImageView).image = UIImage(named: "Discussions")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        } else if linktype == "URL" || linktype == "LINK" || linktype == "osv-kaltura" || linktype == "resource/x-bb-externallink" || linktype == "resource/x-bb-document" || linktype == "resource/x-bb-file" || linktype == "resource/mcgraw-hill-assignment-dynamic" {
            (cell?.contentView.viewWithTag(kImageViewId) as UIImageView).image = UIImage(named: "Document")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        } else if linktype == "announcements" {
            (cell?.contentView.viewWithTag(kImageViewId) as UIImageView).image = UIImage(named: "Announcements")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let linktype = mapItems[indexPath.row]["linktype"] as String
        if linktype == "CONTENT" || linktype == "resource/x-bb-folder" {
            let detailVC = BBCourseViewController()
            let mapItemObject = mapItems[indexPath.row]["children"]!["map-item"]
            if let mapItemArray = mapItemObject as? [NSDictionary] {
                detailVC.mapItems = mapItemArray
            } else {
                detailVC.mapItems = [mapItemObject as NSDictionary]
            }
            detailVC.courseId = courseId
            detailVC.navigationItem.title = mapItems[indexPath.row]["name"] as String!
            detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else if linktype == "student_gradebook" {
            let webBrowser = WebBrowserViewController()
            webBrowser.navigationItem.title = mapItems[indexPath.row]["name"] as String!
            webBrowser.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            let viewurl = mapItems[indexPath.row]["viewurl"] as String!
            webBrowser.urlString = "https://mycourses.purdue.edu\(viewurl)"
            self.navigationController?.pushViewController(webBrowser, animated: true)
        } else if linktype == "discussion_board" {
            let webBrowser = WebBrowserViewController()
            webBrowser.navigationItem.title = mapItems[indexPath.row]["name"] as String!
            webBrowser.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            let viewurl = mapItems[indexPath.row]["viewurl"] as String!
            webBrowser.urlString = "https://mycourses.purdue.edu\(viewurl)"
            self.navigationController?.pushViewController(webBrowser, animated: true)
        } else if linktype == "URL" || linktype == "LINK" || linktype == "osv-kaltura" || linktype == "resource/x-bb-externallink" || linktype == "resource/mcgraw-hill-assignment-dynamic" {
            let webBrowser = WebBrowserViewController()
            webBrowser.navigationItem.title = mapItems[indexPath.row]["name"] as String!
            webBrowser.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            let viewurl = mapItems[indexPath.row]["viewurl"] as String!
            webBrowser.urlString = "https://mycourses.purdue.edu\(viewurl)"
            self.navigationController?.pushViewController(webBrowser, animated: true)
        } else if linktype == "resource/x-bb-document" || linktype == "resource/x-bb-file" {
            let webBrowser = WebBrowserViewController()
            webBrowser.navigationItem.title = mapItems[indexPath.row]["name"] as String!
            webBrowser.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            let viewurl = mapItems[indexPath.row]["viewurl"] as String!
            webBrowser.urlString = "https://mycourses.purdue.edu\(viewurl)"
            self.navigationController?.pushViewController(webBrowser, animated: true)
        } else if linktype == "announcements" {
            let detailVC = BBAnnoucementsViewController()
            detailVC.courseId = self.courseId!
            detailVC.navigationItem.title = mapItems[indexPath.row]["name"] as String!
            detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

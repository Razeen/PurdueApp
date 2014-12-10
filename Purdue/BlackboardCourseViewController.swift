//
//  BlackboardCourseViewController.swift
//  Purdue
//
//  Created by George Lo on 12/5/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class BlackboardCourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var courseid: NSString?
    let progress = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30 ) / 2, 84 + 20, 30, 30))
    var mapItems: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Blackboard"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(progress)
        progress.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var err: NSError?
            var str: NSString = "https://mycourses.purdue.edu/webapps/Bb-mobile-BBLEARN/courseMap?v=1&f=xml&ver=4.1.2&registration_id=11946&course_id=\(self.courseid!)"
            let dict = XMLReader.dictionaryForXMLData(NSData(contentsOfURL: NSURL(string: str)!), error: &err) as NSDictionary!
            self.mapItems = ((dict["mobileresponse"] as NSDictionary)["map"] as NSDictionary)["map-item"] as [NSDictionary]!
            for mapItem in self.mapItems! {
                if mapItem["linktype"] as String! == "DIVIDER" {
                    self.mapItems?.removeAtIndex(find(self.mapItems!, mapItem)!)
                }
            }
            println(self.mapItems)
            dispatch_async(dispatch_get_main_queue(), {
                self.progress.stopAnimating()
                self.progress.removeFromSuperview()
                let tableView = UITableView(frame: CGRectZero)
                tableView.rowHeight = 60
                tableView.dataSource = self
                tableView.delegate = self
                self.view = tableView
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
        cell?.textLabel?.text = mapItems![indexPath.row]["name"] as String!
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        let viewController = MyMailMessagesViewController()
        viewController.navigationItem.title = pathCache[indexPath.row]
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        viewController.navigationItem.leftBarButtonItem?.tintColor = UIColor(white: 0.3, alpha: 1.0)
        viewController.folderName = folders![indexPath.row].path
        self.navigationController?.pushViewController(viewController, animated: true)*/
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

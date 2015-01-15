//
//  BBAnnoucementsViewController.swift
//  Purdue
//
//  Created by George Lo on 1/11/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

class BBAnnoucementsViewController: UITableViewController, UIWebViewDelegate {
    
    var courseId: NSString?
    var announcements: [NSDictionary] = []
    
    var textLabelFrames: [CGRect] = []
    var detailTextLabelFrames: [CGRect] = []
    var webViewFrames: [CGRect] = []
    var rowHeights: [CGFloat] = []
    
    let sem = dispatch_semaphore_create(0)
    
    let serverDateFormatter = NSDateFormatter() // "yyyy-MM-dd'T'HH:mm:ssZZZ"
    let clientDateFormatter = NSDateFormatter() // "hh:mm a MMM dd, yyyy"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 50
        let progress = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30 ) / 2, 10, 30, 30))
        progress.tintColor = ColorUtils.Legacy.OldGold
        progress.startAnimating()
        self.view.addSubview(progress)
        
        serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        clientDateFormatter.dateFormat = "hh:mm a MMM dd, yyyy"
        
        var tempWebViews: [UIWebView] = []
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var err: NSError?
            var str: NSString = "https://mycourses.purdue.edu/webapps/Bb-mobile-BBLEARN/courseData?v=1&f=xml&ver=4.1.2&registration_id=11946&course_id=\(self.courseId!)&course_section=ANNOUNCEMENTS&rich_content_level=RICH"
            let dict = XMLReader.dictionaryForXMLData(NSData(contentsOfURL: NSURL(string: str)!), error: &err) as NSDictionary!
            self.announcements = ((dict["mobileresponse"] as NSDictionary)["announcements"] as NSDictionary)["announcement"] as [NSDictionary]!
            for announcement in self.announcements {
                dispatch_async(dispatch_get_main_queue(), {
                    let textLabel = UILabel(frame: CGRectMake(15, 5, UIScreen.mainScreen().bounds.width - 30, 0))
                    textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
                    textLabel.numberOfLines = 0
                    textLabel.text = announcement["subject"] as String!
                    textLabel.sizeToFit()
                    self.textLabelFrames.append(CGRectMake(15, 5, UIScreen.mainScreen().bounds.width - 30, textLabel.frame.height))
                    
                    let detailTextLabel = UILabel(frame: CGRectMake(15, textLabel.frame.origin.y + textLabel.frame.height + 5, UIScreen.mainScreen().bounds.width - 30, 0))
                    detailTextLabel.font = UIFont(name: "HelveticaNeue-Italic", size: 14)
                    detailTextLabel.numberOfLines = 0
                    let date = self.serverDateFormatter.dateFromString(announcement["startdate"] as NSString!)
                    let displayName = announcement["userdisplayname"] as String!
                    detailTextLabel.text = "\(displayName) \(self.clientDateFormatter.stringFromDate(date!))"
                    detailTextLabel.sizeToFit()
                    self.detailTextLabelFrames.append(CGRectMake(15, textLabel.frame.origin.y + textLabel.frame.height + 5, UIScreen.mainScreen().bounds.width - 30, detailTextLabel.frame.height))
                    
                    let webView = UIWebView(frame: CGRectMake(10, detailTextLabel.frame.origin.y + detailTextLabel.frame.height + 5, UIScreen.mainScreen().bounds.width - 20, 100))
                    webView.delegate = self
                    webView.loadHTMLString(announcement["text"] as NSString!, baseURL: nil)
                    self.view.addSubview(webView)
                    tempWebViews.append(webView)
                })
            }
            
            dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER)
            
            dispatch_async(dispatch_get_main_queue(), {
                for webView in tempWebViews {
                    webView.removeFromSuperview()
                }
            })
            
            for (var i = 0; i < self.announcements.count; i++) {
                let textLabelFrame = self.textLabelFrames[i]
                let detailTextLabelFrame = self.detailTextLabelFrames[i]
                let webViewFrame = self.webViewFrames[i]
                let rowHeight = textLabelFrame.height + detailTextLabelFrame.height + webViewFrame.height + 10
                self.rowHeights.append(rowHeight)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                progress.stopAnimating()
                progress.removeFromSuperview()
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            })
        })
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webViewFrames.append(CGRectMake(10, webView.frame.origin.y, UIScreen.mainScreen().bounds.width - 20, webView.scrollView.contentSize.height))
        if self.announcements.count == webViewFrames.count {
            dispatch_semaphore_signal(sem)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.announcements.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let textLabelTag = 101
        let detailTextLabelTag = 102
        let webViewTag = 103
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            
            let textLabel = UILabel(frame: textLabelFrames[indexPath.row])
            textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
            textLabel.tag = textLabelTag
            textLabel.numberOfLines = 0
            cell?.contentView.addSubview(textLabel)
            
            let detailTextLabel = UILabel(frame: detailTextLabelFrames[indexPath.row])
            detailTextLabel.font = UIFont(name: "HelveticaNeue-Italic", size: 14)
            detailTextLabel.tag = detailTextLabelTag
            detailTextLabel.numberOfLines = 0
            cell?.contentView.addSubview(detailTextLabel)
            
            let webView = UIWebView(frame: webViewFrames[indexPath.row])
            webView.userInteractionEnabled = false
            webView.tag = webViewTag
            cell?.contentView.addSubview(webView)
        }
        
        (cell?.contentView.viewWithTag(textLabelTag) as UILabel).text = self.announcements[indexPath.row]["subject"] as String!
        let date = self.serverDateFormatter.dateFromString(self.announcements[indexPath.row]["startdate"] as NSString!)
        let displayName = self.announcements[indexPath.row]["userdisplayname"] as String!
        (cell?.contentView.viewWithTag(detailTextLabelTag) as UILabel).text = "\(displayName) \(self.clientDateFormatter.stringFromDate(date!))"
        (cell?.contentView.viewWithTag(webViewTag) as UIWebView).loadHTMLString(self.announcements[indexPath.row]["text"] as String!, baseURL: nil)

        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

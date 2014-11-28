//
//  NewsViewController.swift
//  Purdue
//
//  Created by George Lo on 9/27/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, UIActionSheetDelegate {
    
    var news: NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Featured"
        self.tableView.rowHeight = 104
        let academicItem = UIBarButtonItem(image: UIImage(named: "NewsAcademics"), style: .Done, target: self, action: "showAcademicOptions")
        academicItem.tintColor = UIColor(white: 0.3, alpha: 1.0)
        let topicItem = UIBarButtonItem(image: UIImage(named: "NewsTopics"), style: .Done, target: self, action: "showTopicOptions")
        topicItem.tintColor = UIColor(white: 0.3, alpha: 1.0)
        self.navigationItem.rightBarButtonItems = [topicItem, academicItem]
        loadURL("http://www.purdue.edu/newsroom/rss/FeaturedNews.xml")
    }
    
    func showAcademicOptions() {
        UIActionSheet(title: "Academic Areas", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "College of Agriculture", "Discovery Park", "Education", "Engagement", "Engineering", "Health and Human Sciences", "VP Information Technology", "Liberal Arts", "Libraries", "Management - Krannert", "Network for Earthquake Engineering Simulation", "Nursing", "Pharmacy", "Office of the President", "Research Park", "Science", "Technology", "Veterinary Medicine").showFromBarButtonItem(self.navigationItem.rightBarButtonItems![1] as UIBarButtonItem, animated: true)
    }
    
    func showTopicOptions() {
        UIActionSheet(title: "Topics", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Academics", "VP for Development", "Agricultural", "Business", "Community", "Diversity", "Education and Career", "Event", "Faculty and Staff", "Featured", "General", "Health, Medical", "Human Resources", "Information Technology", "Lifestyles, Consumer", "Life Sciences", "Technology Commercialization", "Outreach", "Physical Sciences", "Research Foundation", "Research", "Students", "Veterinary Medicine").showFromBarButtonItem(self.navigationItem.rightBarButtonItems![1] as UIBarButtonItem, animated: true)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex > 0) { // Not Cancel nor Destructive
            var urlStr: NSString = ""
            if (actionSheet.title == "Academic Areas") {
                let dict = [
                    1: "http://www.purdue.edu/newsroom/rss/AgNews.xml",
                    2: "http://www.purdue.edu/newsroom/rss/DiscoParkNews.xml",
                    3: "http://www.purdue.edu/newsroom/rss/EdNews.xml",
                    4: "http://www.purdue.edu/newsroom/rss/EngageNews.xml",
                    5: "http://www.purdue.edu/newsroom/rss/engineering.xml",
                    6: "http://www.purdue.edu/newsroom/rss/HHSNews.xml",
                    7: "http://www.purdue.edu/newsroom/rss/ITaPNews.xml",
                    8: "http://www.purdue.edu/newsroom/rss/CLANews.xml",
                    9: "http://www.purdue.edu/newsroom/rss/LibrariesNews.xml",
                    10: "http://www.purdue.edu/newsroom/rss/KrannertNews.xml",
                    11: "http://www.purdue.edu/newsroom/rss/NEESnews.xml",
                    12: "http://www.purdue.edu/newsroom/rss/NursingNews.xml",
                    13: "http://www.purdue.edu/newsroom/rss/PharmacyNews.xml",
                    14: "http://www.purdue.edu/newsroom/rss/president.xml",
                    15: "http://www.purdue.edu/newsroom/rss/PRFNews.xml",
                    16: "http://www.purdue.edu/newsroom/rss/ScienceNews.xml",
                    17: "http://www.purdue.edu/newsroom/rss/TechNews.xml",
                    18: "http://www.purdue.edu/newsroom/rss/VetNews.xml"
                ]
                urlStr = dict[buttonIndex]!
            } else {
                let dict = [
                    1: "http://www.purdue.edu/newsroom/rss/academics.xml",
                    2: "http://www.purdue.edu/newsroom/rss/AdvNews.xml",
                    3: "http://www.purdue.edu/newsroom/rss/AgriNews.xml",
                    4: "http://www.purdue.edu/newsroom/rss/BizNews.xml",
                    5: "http://www.purdue.edu/newsroom/rss/community.xml",
                    6: "http://www.purdue.edu/newsroom/rss/DiversityNews.xml",
                    7: "http://www.purdue.edu/newsroom/rss/EdCareerNews.xml",
                    8: "http://www.purdue.edu/newsroom/rss/EventNews.xml",
                    9: "http://www.purdue.edu/newsroom/rss/faculty_staff.xml",
                    10: "http://www.purdue.edu/newsroom/rss/FeaturedNews.xml",
                    11: "http://www.purdue.edu/newsroom/rss/general.xml",
                    12: "http://www.purdue.edu/newsroom/rss/HealthMedNews.xml",
                    13: "http://www.purdue.edu/newsroom/rss/hrnews.xml",
                    14: "http://www.purdue.edu/newsroom/rss/InfoTech.xml",
                    15: "http://www.purdue.edu/newsroom/rss/LifeNews.xml",
                    16: "http://www.purdue.edu/newsroom/rss/LifeSciNews.xml",
                    17: "http://www.purdue.edu/newsroom/rss/OTCNews.xml",
                    18: "http://www.purdue.edu/newsroom/rss/outreach.xml",
                    19: "http://www.purdue.edu/newsroom/rss/PhysicalSciNews.xml",
                    20: "http://www.purdue.edu/newsroom/rss/PRFAdminNews.xml",
                    21: "http://www.purdue.edu/newsroom/rss/ResearchNews.xml",
                    22: "http://www.purdue.edu/newsroom/rss/StudentNews.xml",
                    23: "http://www.purdue.edu/newsroom/rss/VetMedNews.xml"
                ]
                urlStr = dict[buttonIndex]!
            }
            self.navigationItem.title = actionSheet.buttonTitleAtIndex(buttonIndex)
            loadURL(urlStr)
        }
    }
    
    func loadURL(urlStr: NSString) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.news.removeAllObjects()
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            })
        })
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var error: NSError?
            var data: NSData = NSData(contentsOfURL: NSURL(string: urlStr)!, options: NSDataReadingOptions.UncachedRead, error: &error)!
            let dict: NSDictionary = XMLReader.dictionaryForXMLData(data, error: &error)
            let rss: NSDictionary = dict["rss"] as NSDictionary
            let channel: NSDictionary = rss["channel"] as NSDictionary
            let items: NSArray = channel["item"] as NSArray
            for item: NSDictionary in items as [NSDictionary] {
                let title: String = (item["title"] as NSDictionary).objectForKey("text") as String
                let desc: String = (item["description"] as NSDictionary).objectForKey("text") as String
                let date: String = (item["pubDate"] as NSDictionary).objectForKey("text") as String
                let link: String = (item["link"] as NSDictionary).objectForKey("text") as String
                let news: News = News(title: title, desc: desc, date: date, link: link)
                self.news.addObject(news)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
            }
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
        return news.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        let kTitleTag = 101
        let kDetailTag = 102
        let kDateTag = 103
        let kTimeTag = 104
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            
            let imageIV: UIImageView = UIImageView(image: UIImage(named: "RSS"))
            imageIV.frame = CGRectMake(15, 15, 25, 25)
            cell?.contentView.addSubview(imageIV)
            
            let titleTV: UITextView = UITextView(frame: CGRectMake(45, 2, UIScreen.mainScreen().bounds.width*7/10, 52))
            titleTV.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15)
            titleTV.tag = kTitleTag
            titleTV.scrollEnabled = false
            titleTV.userInteractionEnabled = false
            titleTV.textContainer.maximumNumberOfLines = 2
            titleTV.textContainer.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            cell?.contentView.addSubview(titleTV)
            
            let detailTV: UITextView = UITextView(frame: CGRectMake(45, 42, UIScreen.mainScreen().bounds.width-45-10, 66))
            detailTV.font = UIFont(name: "AppleSDGothicNeo-Light", size: 13)
            detailTV.tag = kDetailTag
            detailTV.scrollEnabled = false
            detailTV.userInteractionEnabled = false
            detailTV.textContainer.maximumNumberOfLines = 3
            detailTV.textContainer.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            cell?.contentView.addSubview(detailTV)
            
            let dateLabel: UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width-40-10, 10, 40, 15))
            dateLabel.font = UIFont(name: "AvenirNext-Italic", size: 12)
            dateLabel.textColor = UIColor.grayColor()
            dateLabel.tag = kDateTag
            cell?.contentView.addSubview(dateLabel)
            
            let timeLabel: UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width-40-10, 25, 40, 15))
            timeLabel.font = UIFont(name: "AvenirNext-Italic", size: 12)
            timeLabel.textColor = UIColor.grayColor()
            timeLabel.tag = kTimeTag
            cell?.contentView.addSubview(timeLabel)
        }
        
        (cell?.contentView.viewWithTag(kTitleTag) as UITextView).text = (news[indexPath.row] as News).title
        (cell?.contentView.viewWithTag(kDetailTag) as UITextView).text = (news[indexPath.row] as News).desc
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        (cell?.contentView.viewWithTag(kDateTag) as UILabel).text = dateFormatter.stringFromDate((news[indexPath.row] as News).date)
        dateFormatter.dateFormat = "HH:mm"
        (cell?.contentView.viewWithTag(kTimeTag) as UILabel).text = dateFormatter.stringFromDate((news[indexPath.row] as News).date)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = NewsDetailViewController()
        detailVC.url = (news[indexPath.row] as News).link
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        detailVC.navigationItem.leftBarButtonItem?.tintColor = UIColor(white: 0.3, alpha: 1.0)
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

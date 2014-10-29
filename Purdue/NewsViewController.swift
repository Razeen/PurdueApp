//
//  NewsViewController.swift
//  Purdue
//
//  Created by George Lo on 9/27/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    var news: NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Featured"
        self.tableView.rowHeight = 100
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var error: NSError?
            var data: NSData = NSData(contentsOfURL: NSURL(string: "http://www.purdue.edu/newsroom/rss/FeaturedNews.xml")!, options: NSDataReadingOptions.UncachedRead, error: &error)!
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
        let kImageViewId = 101
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell!.textLabel.text = news[indexPath.row].title
        cell?.textLabel.textColor = UIColor(red: 163.0/255.0, green: 121.0/255.0, blue: 44.0/255.0, alpha: 1)
        cell?.textLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        
        return cell!
    }
    
}

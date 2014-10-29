//
//  News.swift
//  Purdue
//
//  Created by George Lo on 9/27/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class News: NSObject {
    var title: String
    var desc: String
    var date: NSDate
    var link: NSURL
    
    init(title: String, desc: String, date: NSString, link: NSString) {
        self.title = title
        self.desc = desc
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        self.date = dateFormatter.dateFromString(date)!
        self.link = NSURL(string: link.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
    }
}

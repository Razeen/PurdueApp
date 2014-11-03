//
//  Video.swift
//  Purdue
//
//  Created by George Lo on 10/30/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class Video: NSObject {
    var title: String?
    var duration: String?
    var url: NSURL?
    var thumbnailUrl: NSURL?
    var uploadTime: NSDate?
    var views: String?
    
    init(title: String, duration: String, url: NSURL, thumbnailUrl: NSURL, uploadTime: NSDate, views: String) {
        self.title = title
        self.duration = duration
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.uploadTime = uploadTime
        self.views = views
    }
   
}

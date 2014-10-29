//
//  Photo.swift
//  Purdue
//
//  Created by George Lo on 10/14/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class Photo: NSObject {
    var imageId: String
    var galleryId: String
    var name: String
    var numImages: Int
    var time: NSDate
    
    override init() {
        self.imageId = String()
        self.galleryId = String()
        self.name = String()
        self.numImages = Int()
        self.time = NSDate()
    }
    
    func setTime(time: String) {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd HH:mm:ss ZZZ"
        self.time = dateFormatter.dateFromString(time)!
    }
    
    init(imageId: String, galleryId: String, name: String, numImages: Int, time: String) {
        self.imageId = imageId
        self.galleryId = galleryId
        self.name = name
        self.numImages = numImages
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd HH:mm:ss ZZZ"
        self.time = dateFormatter.dateFromString(time)!
    }
}

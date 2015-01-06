//
//  Route.swift
//  Purdue
//
//  Created by George Lo on 12/28/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class Route: NSObject {
    var id: Int = 0
    var name: NSString?
    var short_name: NSString?
    var desc: NSString?
    var color: UIColor?
    var path: NSArray?
    var stops: NSArray?
    var image: UIImage?
    
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as Int
        self.name = aDecoder.decodeObjectForKey("name") as? NSString
        self.short_name = aDecoder.decodeObjectForKey("short_name") as? NSString
        self.desc = aDecoder.decodeObjectForKey("desc") as? NSString
        self.color = aDecoder.decodeObjectForKey("color") as? UIColor
        self.path = aDecoder.decodeObjectForKey("path") as? NSArray
        self.stops = aDecoder.decodeObjectForKey("stops") as? NSArray
        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        if let name = self.name {
            aCoder.encodeObject(name, forKey: "name")
        }
        if let short_name = self.short_name {
            aCoder.encodeObject(short_name, forKey: "short_name")
        }
        if let desc = self.desc {
            aCoder.encodeObject(desc, forKey: "desc")
        }
        if let color = self.color {
            aCoder.encodeObject(color, forKey: "color")
        }
        if let path = self.path {
            aCoder.encodeObject(path, forKey: "path")
        }
        if let stops = self.stops {
            aCoder.encodeObject(stops, forKey: "stops")
        }
        if let image = self.image {
            aCoder.encodeObject(image, forKey: "image")
        }
    }

}

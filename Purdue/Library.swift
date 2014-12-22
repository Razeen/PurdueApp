//
//  Library.swift
//  Purdue
//
//  Created by George Lo on 12/21/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class Library: NSObject {
    var name: NSString?
    var location: NSString?
    var latitude: Double
    var longitude: Double
    
    init(name: NSString, location: NSString, latitude: Double, longitude: Double) {
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
}

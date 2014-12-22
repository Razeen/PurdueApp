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
    var imageName: NSString?
    var latitude: Double
    var longitude: Double
    var phone: NSString?
    var email: NSString?
    var address: NSString?
    var hours: NSString?
    var note: NSString?
    
    init(name: NSString, location: NSString, imageName: NSString, latitude: Double, longitude: Double, phone: NSString, email: NSString, address: NSString, hours: NSString) {
        self.name = name
        self.location = location
        self.imageName = imageName
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.email = email
        self.address = address
        self.hours = hours
    }
    
    init(name: NSString, location: NSString, imageName: NSString, latitude: Double, longitude: Double, phone: NSString, email: NSString, address: NSString, hours: NSString, note: NSString?) {
        self.name = name
        self.location = location
        self.imageName = imageName
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.email = email
        self.address = address
        self.hours = hours
        self.note = note
    }

}

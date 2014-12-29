//
//  Building.swift
//  Purdue
//
//  Created by George Lo on 12/23/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class Building: NSObject {
    var fullname: String?
    var abbreviation: String?
    var latitude: Double
    var longitude: Double
    
    init(fullname: String, abbreviation: String, latitude: Double, longitude: Double) {
        self.fullname = fullname
        self.abbreviation = abbreviation
        self.latitude = latitude
        self.longitude = longitude
    }
}

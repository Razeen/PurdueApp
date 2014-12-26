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
    
    init(fullname: String, abbreviation: String) {
        self.fullname = fullname
        self.abbreviation = abbreviation
    }
}

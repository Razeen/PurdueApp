//
//  Stop.swift
//  Purdue
//
//  Created by George Lo on 12/28/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class Stop: NSObject {
    var id: Int = 0
    var name: NSString?
    var desc: NSString?
    var coordinate: CLLocationCoordinate2D?
    
    required override init() {
        super.init()
    }
}

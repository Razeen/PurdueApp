//
//  StopAnnotation.swift
//  Purdue
//
//  Created by George Lo on 1/6/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

class StopAnnotation: NSObject, MKAnnotation, QTreeInsertable {
    var coordinate: CLLocationCoordinate2D
    var title: String
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}

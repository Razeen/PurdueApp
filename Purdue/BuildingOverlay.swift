//
//  BuildingOverlay.swift
//  Purdue
//
//  Created by George Lo on 12/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class BuildingOverlay: NSObject, MKOverlay  {
    
    let southWest = CLLocationCoordinate2DMake(40.409712, -86.945601)
    let northEast = CLLocationCoordinate2DMake(40.444526, -86.907749)
    
    var boundingMapRect: MKMapRect {
        get {
            let bottomLeft = MKMapPointForCoordinate(southWest)
            let upperRight = MKMapPointForCoordinate(northEast)
            return MKMapRectMake(bottomLeft.x, upperRight.y, fabs(bottomLeft.x - upperRight.x), fabs(upperRight.y - bottomLeft.y))
        }
    }
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake((northEast.latitude + southWest.latitude) / 2, (northEast.longitude + southWest.longitude) / 2)
        }
    }
    
}

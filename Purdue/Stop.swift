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
    var idArray: [Int] = []
    var name: NSString?
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as Int
        self.idArray = aDecoder.decodeObjectForKey("idArray") as [Int]
        self.name = aDecoder.decodeObjectForKey("name") as? NSString
        self.coordinate = CLLocationCoordinate2DMake(aDecoder.decodeDoubleForKey("lat"), aDecoder.decodeDoubleForKey("lon"))
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        if let name = self.name {
            aCoder.encodeObject(name, forKey: "name")
        }
        aCoder.encodeObject(idArray, forKey: "idArray")
        aCoder.encodeDouble(coordinate.latitude, forKey: "lat")
        aCoder.encodeDouble(coordinate.longitude, forKey: "lon")
    }
}

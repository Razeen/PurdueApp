//
//  LabBuilding.swift
//  Purdue
//
//  Created by George Lo on 11/9/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class LabBuilding: NSObject {
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var availability: Int = 0
    var rooms: [LabRoom] = []
    
    override init() {
    }
    
    func addLabRoom(room: LabRoom) {
        rooms.append(room);
    }
}

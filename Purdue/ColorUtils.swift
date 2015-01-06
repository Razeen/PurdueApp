//
//  ColorUtils.swift
//  Purdue
//
//  Created by George Lo on 12/27/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class ColorUtils: NSObject {
    struct Legacy {
        static let Black = UIColor.blackColor
        static let OldGold = UIColor(red: 163.0/255, green: 121.0/255, blue: 44.0/255, alpha: 1)
    }
    
    struct Core {
        static let Brown = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1)
        static let DarkGray = UIColor(red: 116.0/255, green: 108.0/255, blue: 102.0/255, alpha: 1)
        static let Gray = UIColor(red: 167.0/255, green: 169.0/255, blue: 172.0/255, alpha: 1)
        static let LightGray = UIColor(red: 209.0/255, green: 211.0/255, blue: 212.0/255, alpha: 1)
        static let White = UIColor.whiteColor()
    }
    
    struct Cool {
        static let DarkBlue = UIColor(red: 114.0/255, green: 153.0/255, blue: 198.0/255, alpha: 1)
    }
}

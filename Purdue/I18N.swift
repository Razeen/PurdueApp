//
//  I18N.swift
//  Purdue
//
//  Created by George Lo on 12/25/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

var _bundle: NSBundle?
var _language: NSString?

class I18N: NSObject {
    
    override class func initialize() {
        self.setLanguage((NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as NSArray)[0] as NSString)
    }
    
    class func setLanguage(languageCode: NSString) {
        NSUserDefaults.standardUserDefaults().setObject(NSArray(object: languageCode), forKey: "AppleLanguages")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        _bundle = NSBundle(path: NSBundle.mainBundle().pathForResource(languageCode, ofType: "lproj")!)
    }
    
    class func localizedString(key: NSString) -> NSString {
        return _bundle!.localizedStringForKey(key, value: "", table: nil) as NSString
    }
    
}

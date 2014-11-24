//
//  AccountUtils.swift
//  Purdue
//
//  Created by George Lo on 11/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class AccountUtils: NSObject {
    class func getUsername() -> String? {
        return KeychainWrapper.stringForKey("Username")
    }
    
    class func setUsername(username: String) {
        KeychainWrapper.setString(username, forKey: "Username")
    }
    
    class func removeUsername() {
        KeychainWrapper.removeObjectForKey("Username")
    }
    
    class func getPassword() -> String? {
        return KeychainWrapper.stringForKey("Password")
    }
    
    class func setPassword(password: String) {
        KeychainWrapper.setString(password, forKey: "Password")
    }
    
    class func removePassword() {
        KeychainWrapper.removeObjectForKey("Password")
    }
}

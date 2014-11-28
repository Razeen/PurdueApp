//
//  AccountUtils.swift
//  Purdue
//
//  Created by George Lo on 11/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class AccountUtils: NSObject {
    struct Static {
        static var session: MCOIMAPSession?
    }
    
    class var sharedIMAPSession: MCOIMAPSession {
        if Static.session == nil {
            Static.session = getIMAPSession()
        }
        
        return Static.session!
    }

    class func getIMAPSession() -> MCOIMAPSession {
        let session = MCOIMAPSession()
        session.hostname = "mymail.purdue.edu"
        session.username = AccountUtils.getUsername()!
        session.password = AccountUtils.getPassword()!
        session.port = 993 // MyMail TLS Protocol port
        session.connectionType = MCOConnectionType.TLS
        return session
    }
    
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

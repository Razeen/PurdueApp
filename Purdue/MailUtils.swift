//
//  MailUtils.swift
//  Purdue
//
//  Created by George Lo on 11/25/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class MailUtils: NSObject {
    class func getFolders() {
        let session = MCOIMAPSession()
        session.hostname = "mymail.purdue.edu"
        session.username = AccountUtils.getUsername()!
        session.password = AccountUtils.getPassword()!
        session.port = 993 // MyMail TLS Protocol port
        session.connectionType = MCOConnectionType.TLS
        session.fetchAllFoldersOperation().start( { (err: NSError!, folders: [AnyObject]!) in
            NSNotificationCenter.defaultCenter().postNotificationName("GotFolders", object: self, userInfo: ["Mail": folders])
        })
    }
}

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
        AccountUtils.sharedIMAPSession.fetchAllFoldersOperation().start( { (err: NSError!, folders: [AnyObject]!) in
            NSNotificationCenter.defaultCenter().postNotificationName("GotFolders", object: self, userInfo: ["Mail": folders])
        })
    }
    
    class func getMessages(folderName: NSString) {
        let requestKind = MCOIMAPMessagesRequestKind.FullHeaders | MCOIMAPMessagesRequestKind.Flags | MCOIMAPMessagesRequestKind.Structure
        let uids = MCOIndexSet(range: MCORangeMake(1, UINT64_MAX))
        
        AccountUtils.sharedIMAPSession.fetchMessagesOperationWithFolder(folderName, requestKind: requestKind, uids: uids).start( {
            (err: NSError!, fetchedMessages: [AnyObject]!, vanishedMessages: MCOIndexSet!) in
            NSNotificationCenter.defaultCenter().postNotificationName("GotMessages", object: self, userInfo: ["Mail": fetchedMessages.reverse()])
        })
    }
    
    class func getBody(folderName: String!, message: MCOIMAPMessage) {
        
    }
}

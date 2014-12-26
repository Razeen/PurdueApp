//
//  MyMailMailsViewController.swift
//  Purdue
//
//  Created by George Lo on 11/26/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class MyMailMessagesViewController: UITableViewController {
    
    var folderName: NSString?
    let progress = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30 ) / 2, 20, 30, 30))
    var messages: [MCOIMAPMessage] = []
    var bodyCache: NSMutableDictionary = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(progress)
        progress.startAnimating()
        
        AccountUtils.sharedIMAPSession.fetchMessagesOperationWithFolder(folderName,
            requestKind: MCOIMAPMessagesRequestKind.FullHeaders | MCOIMAPMessagesRequestKind.Flags | MCOIMAPMessagesRequestKind.Structure,
            uids: MCOIndexSet(range: MCORangeMake(1, UINT64_MAX))
            ).start( {
            (err: NSError!, fetchedMessages: [AnyObject]!, vanishedMessages: MCOIndexSet!) in
            self.messages = fetchedMessages.reverse() as [MCOIMAPMessage]
            
            self.progress.stopAnimating()
            self.progress.removeFromSuperview()
            
            self.tableView.separatorColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.rowHeight = 90
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return messages.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? MessagesCell
        
        let kReadTag = 101
        let kFromTag = 102
        let kSubjectTag = 103
        let kDescTag = 104

        if cell == nil {
            cell = MessagesCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        if messages[indexPath.row].flags == MCOMessageFlag.None {
            cell?.readView.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        }
        
        if messages[indexPath.row].header.from.displayName != nil {
            cell?.fromLabel.text = messages[indexPath.row].header.from.displayName
        } else {
            cell?.fromLabel.text = messages[indexPath.row].header.from.mailbox.stringByReplacingOccurrencesOfString("@purdue.edu", withString: "")
        }
        
        if countElements(messages[indexPath.row].header.subject) > 0 {
            cell?.subjectLabel.text = messages[indexPath.row].header.subject
            cell?.subjectLabel.textColor = UIColor.blackColor()
        } else {
            cell?.subjectLabel.text = "No Subject"
            cell?.subjectLabel.textColor = UIColor.grayColor()
        }
        
        let uid = NSNumber(unsignedInt: messages[indexPath.row].uid)
        let cachedString = bodyCache[uid] as? String
        
        if cachedString != nil {
            cell?.descLabel.text = cachedString
        } else {
            cell?.messageRenderingOperation = AccountUtils.sharedIMAPSession.plainTextBodyRenderingOperationWithMessage(messages[indexPath.row], folder: folderName)
            cell?.messageRenderingOperation?.start({
                (string: String!, err: NSError!) in
                var bodyString = string
                if (countElements(bodyString!) < 60) {
                    bodyString = "\(bodyString!)\n"
                }
                
                cell?.descLabel.text = bodyString
                cell?.messageRenderingOperation = nil
                self.bodyCache[uid] = bodyString
            })
        }
        
        cell?.setDate(messages[indexPath.row].header.date)
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = MyMailBodyViewController()
        viewController.navigationItem.title = "Mail"
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        viewController.message = messages[indexPath.row]
        viewController.folder = folderName!
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

//
//  MyMailViewController.swift
//  Purdue
//
//  Created by George Lo on 9/30/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class MyMailFolderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var signInBtn: BButton?
    var viewController: UIViewController?
    let progress = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30 ) / 2, 84 + 20, 30, 30))
    var folders: [MCOIMAPFolder]?
    
    // Can convert to NSCache
    var pathCache: [String] = []
    var subCount: [Int] = []
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: "signInSuccess", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func receivedNotification(notification: NSNotification) {
        if notification.name == "signInSuccess" {
            signInBtn!.enabled = true
            self.navigationItem.leftBarButtonItem?.enabled = true
            loadFolders()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MyMail"
        viewController = SignInViewController(source: (UIApplication.sharedApplication().delegate as AppDelegate).slidingViewController!)
        
        if AccountUtils.getUsername() == nil || AccountUtils.getPassword() == nil {
            let defaultHeight = CGFloat(20 + 64) // StatusBar + NavigationBar
            
            let oopsLabel = UILabel(frame: CGRectMake(0, defaultHeight + UIScreen.mainScreen().bounds.height / 10 * 0.5, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 10 * 1.5))
            oopsLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
            oopsLabel.textAlignment = NSTextAlignment.Center
            oopsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 60)
            oopsLabel.text = I18N.localizedString("BLACKBOARD_OOPS")
            self.view.addSubview(oopsLabel)
            
            let hintLabel = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height / 10 * 2.25 + defaultHeight, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 10 * 1.5))
            hintLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
            hintLabel.textAlignment = NSTextAlignment.Center
            hintLabel.font = UIFont(name: "ArialRoundedMTBold", size: 24)
            hintLabel.numberOfLines = 2
            hintLabel.text = I18N.localizedString("BLACKBOARD_SIGN_IN_PROMPT")
            self.view.addSubview(hintLabel)
            
            let btnHeight = CGFloat(60)
            signInBtn = BButton(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 160) / 2, UIScreen.mainScreen().bounds.height * 0.425 + defaultHeight, 160, btnHeight), type: BButtonType.Success, style: BButtonStyle.BootstrapV3)
            signInBtn!.setTitle(I18N.localizedString("SIGN_IN"), forState: UIControlState.Normal)
            signInBtn!.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
            signInBtn!.addTarget(self, action: "showSignIn", forControlEvents: UIControlEvents.TouchUpInside)
            signInBtn!.buttonCornerRadius = 7.5
            self.view.addSubview(signInBtn!)
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopup")
            gestureRecognizer.delegate = self
            self.view.addGestureRecognizer(gestureRecognizer)
        }
        else {
            loadFolders()
        }
    }
    
    func dismissPopup() {
        signInBtn!.enabled = true
        self.navigationItem.leftBarButtonItem?.enabled = true
        (UIApplication.sharedApplication().delegate as AppDelegate).slidingViewController?.dismissPopupViewControllerAnimated(true, completion: nil)
    }
    
    func showSignIn() {
        signInBtn!.enabled = false
        self.navigationItem.leftBarButtonItem?.enabled = false
        (UIApplication.sharedApplication().delegate as AppDelegate).slidingViewController?.presentPopupViewController(viewController, animated: true, completion: nil)
    }
    
    func loadFolders() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.view.addSubview(progress)
        progress.startAnimating()
        
        AccountUtils.sharedIMAPSession.fetchAllFoldersOperation().start( { (err: NSError!, folders: [AnyObject]!) in
            self.folders = folders as? [MCOIMAPFolder]
            var inboxFolder: MCOIMAPFolder?
            var chatsFolder: MCOIMAPFolder?
            var sentFolder: MCOIMAPFolder?
            var draftsFolder: MCOIMAPFolder?
            var junkFolder: MCOIMAPFolder?
            var trashFolder: MCOIMAPFolder?
            
            for i in 0 ... folders.count - 6 {
                if self.folders![i].path == "INBOX" {
                    inboxFolder = self.folders![i]
                    self.folders!.removeAtIndex(i)
                } else if self.folders![i].path == "Chats" {
                    chatsFolder = self.folders![i]
                    self.folders!.removeAtIndex(i)
                } else if self.folders![i].path == "Sent" {
                    sentFolder = self.folders![i]
                    self.folders!.removeAtIndex(i)
                } else if self.folders![i].path == "Drafts" {
                    draftsFolder = self.folders![i]
                    self.folders!.removeAtIndex(i)
                } else if self.folders![i].path == "Junk" {
                    junkFolder = self.folders![i]
                    self.folders!.removeAtIndex(i)
                } else if self.folders![i].path == "Trash" {
                    trashFolder = self.folders![i]
                    self.folders!.removeAtIndex(i)
                }
            }
            self.folders!.insert(inboxFolder!, atIndex: 0)
            self.folders!.insert(chatsFolder!, atIndex: 1)
            self.folders!.insert(sentFolder!, atIndex: 2)
            self.folders!.insert(draftsFolder!, atIndex: 3)
            self.folders!.insert(junkFolder!, atIndex: 4)
            self.folders!.insert(trashFolder!, atIndex: 5)
            
            for i in 0 ... folders.count - 1 {
                var pathParts = (self.folders![i].path as NSString).componentsSeparatedByString("/") as [String]
                self.subCount.append(pathParts.count)
                if (i == 0) {
                    self.pathCache.append("Inbox")
                } else {
                    self.pathCache.append(pathParts[pathParts.count - 1])
                }
            }
            
            self.progress.stopAnimating()
            self.progress.removeFromSuperview()
            let tableView = UITableView(frame: CGRectZero)
            tableView.rowHeight = 60
            tableView.dataSource = self
            tableView.delegate = self
            self.view = tableView
        })
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view != viewController!.view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: FolderCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? FolderCell
        
        if cell == nil {
            cell = FolderCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell!.imageView!.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        if indexPath.row <= 5 {
            cell!.imageView!.image = UIImage(named: pathCache[indexPath.row])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        } else {
            cell!.imageView!.image = UIImage(named: "Folder")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        
        cell!.textLabel!.text = pathCache[indexPath.row]
        cell!.textLabel!.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = MyMailMessagesViewController()
        viewController.navigationItem.title = pathCache[indexPath.row]
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        viewController.folderName = folders![indexPath.row].path
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    /* iOS 7 and iOS 8 cell separatorInset and layoutMargins */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.view.isKindOfClass(UITableView.classForCoder()) {
            if (self.view as UITableView).respondsToSelector("setSeparatorInset:") {
                (self.view as UITableView).separatorInset = UIEdgeInsetsMake(0, 20 + 43, 0, 0)
            }
            if (self.view as UITableView).respondsToSelector("setLayoutMargins:") {
                (self.view as UITableView).layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0)
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var count = CGFloat((folders![indexPath.row].path as NSString).componentsSeparatedByString("/").count)
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 20 * count + 43, 0, 0)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsMake(0, 20 * count, 0, 0)
        }
    }
}

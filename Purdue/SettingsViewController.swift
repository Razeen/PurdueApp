//
//  SettingsViewController.swift
//  Purdue
//
//  Created by George Lo on 12/14/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIActionSheetDelegate, UIGestureRecognizerDelegate {
    
    var signOutAS: UIActionSheet?
    var viewController: UIViewController?
    
    convenience override init() {
        self.init(style: UITableViewStyle.Grouped)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: "signInSuccess", object: nil)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
    
    func receivedNotification(notification: NSNotification) {
        if notification.name == "signInSuccess" {
            setSignOutFooter()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewController = SignInViewController(source: self.navigationController!)
        self.navigationItem.title = NSLocalizedString("SETTINGS_TITLE", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: UIBarButtonItemStyle.Done, target: self, action: "dismissViewController")
        
        signOutAS = UIActionSheet(title: "Are you sure you want to sign out?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Sign Out")
        
        if AccountUtils.getUsername() == nil || AccountUtils.getPassword() == nil {
            setSignInFooter()
        } else {
            setSignOutFooter()
        }
        
        self.tableView.rowHeight = 50
    }
    
    func setSignInFooter() {
        let footerView = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 50))
        footerView.text = "SIGN IN"
        footerView.textAlignment = NSTextAlignment.Center
        footerView.textColor = UIColor.whiteColor()
        footerView.backgroundColor = UIColor(red: 46.0/255, green: 204.0/255, blue: 113.0/255, alpha: 1.0)
        footerView.userInteractionEnabled = true
        footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "signIn"))
        self.tableView.tableFooterView = footerView
    }
    
    func signIn() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopup")
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        self.navigationController!.presentPopupViewController(viewController, animated: true, completion: nil)
    }
    
    func dismissPopup() {
        self.navigationController!.dismissPopupViewControllerAnimated(true, completion: nil)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view != viewController!.view
    }
    
    func setSignOutFooter() {
        let footerView = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 50))
        footerView.text = "SIGN OUT"
        footerView.textAlignment = NSTextAlignment.Center
        footerView.textColor = UIColor.whiteColor()
        footerView.backgroundColor = UIColor.redColor()
        footerView.userInteractionEnabled = true
        footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "signOut"))
        self.tableView.tableFooterView = footerView
    }
    
    func signOut() {
        signOutAS?.showFromRect(self.tableView.tableFooterView!.bounds, inView: self.view, animated: true)
    }
    
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
           return "General"
        } else {
            return "Others"
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == numberOfSectionsInTableView(tableView) - 1 {
            return " "
        }
        return nil
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CellIdentifier")
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Language"
                cell?.detailTextLabel?.text = "English"
            }
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet == signOutAS {
            if actionSheet.buttonTitleAtIndex(buttonIndex) == "Sign Out" {
                AccountUtils.removeUsername()
                AccountUtils.removePassword()
                setSignInFooter()
            }
        }
    }

}

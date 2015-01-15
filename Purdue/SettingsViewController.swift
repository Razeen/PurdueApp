//
//  SettingsViewController.swift
//  Purdue
//
//  Created by George Lo on 12/14/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIActionSheetDelegate, UIGestureRecognizerDelegate {
    
    var viewController: UIViewController?
    
    var shouldHideSB = true
    
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
        UIApplication.sharedApplication().setStatusBarHidden(shouldHideSB, withAnimation: UIStatusBarAnimation.None)
    }
    
    func receivedNotification(notification: NSNotification) {
        if notification.name == "signInSuccess" {
            setFooter()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewController = SignInViewController(source: self.navigationController!)
        
        self.navigationItem.title = I18N.localizedString("SETTINGS_TITLE")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: UIBarButtonItemStyle.Done, target: self, action: "dismissViewController")
        
        setFooter()
        
        self.tableView.rowHeight = 50
    }
    
    func setFooter() {
        if AccountUtils.getUsername() == nil || AccountUtils.getPassword() == nil {
            let footerView = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 50))
            footerView.text = I18N.localizedString("UPPERCASE_SIGN_IN")
            footerView.textAlignment = NSTextAlignment.Center
            footerView.textColor = UIColor.whiteColor()
            footerView.backgroundColor = UIColor(red: 46.0/255, green: 204.0/255, blue: 113.0/255, alpha: 1.0)
            footerView.userInteractionEnabled = true
            footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "signIn"))
            self.tableView.tableFooterView = footerView
        } else {
            let footerView = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 50))
            footerView.text = I18N.localizedString("UPPERCASE_SIGN_OUT")
            footerView.textAlignment = NSTextAlignment.Center
            footerView.textColor = UIColor.whiteColor()
            footerView.backgroundColor = UIColor.redColor()
            footerView.userInteractionEnabled = true
            footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "signOut"))
            self.tableView.tableFooterView = footerView
        }
    }
    
    func signIn() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopup")
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        self.navigationController!.presentPopupViewController(viewController, animated: true, completion: nil)
    }
    
    func dismissPopup() {
        shouldHideSB = true
        self.navigationController!.dismissPopupViewControllerAnimated(true, completion: nil)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view != viewController!.view
    }
    
    func signOut() {
        UIActionSheet(title: I18N.localizedString("SETTINGS_SIGNOUT_PROMPT"), delegate: self, cancelButtonTitle: I18N.localizedString("CANCEL"), destructiveButtonTitle: I18N.localizedString("NORMALCASE_SIGN_OUT")).showFromRect(self.tableView.tableFooterView!.bounds, inView: self.view, animated: true)
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
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
           return I18N.localizedString("GENERAL")
        } else {
            return I18N.localizedString("OTHERS")
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == numberOfSectionsInTableView(tableView) - 1 {
            return " "
        }
        return nil
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CellIdentifier")
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = I18N.localizedString("LANGUAGE")
                let languageCode = (NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as NSArray)[0] as String
                if languageCode == "en" {
                    cell?.detailTextLabel?.text = "English"
                } else if languageCode == "zh-Hant" {
                    cell?.detailTextLabel?.text = "繁體中文"
                } else if languageCode == "zh-Hans" {
                    cell?.detailTextLabel?.text = "简体中文"
                } else if languageCode == "ja" {
                    cell?.detailTextLabel?.text = "日本語"
                }
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = I18N.localizedString("DEVELOPMENT_TEAM")
                cell?.detailTextLabel?.text = nil
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = I18N.localizedString("ATTRIBUTIONS")
                cell?.detailTextLabel?.text = nil
            }
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                UIActionSheet(title: I18N.localizedString("SETTINGS_LANG_PROMPT"), delegate: self, cancelButtonTitle: I18N.localizedString("CANCEL"), destructiveButtonTitle: nil, otherButtonTitles: "English", "繁體中文", "简体中文", "日本語").showFromRect(tableView.cellForRowAtIndexPath(indexPath)!.frame, inView: self.view, animated: true)
            }
        } else if indexPath.section == 1 {
            shouldHideSB = false
            if indexPath.row == 0 {
                let detailVC = DevTeamViewController()
                detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
                self.navigationController?.pushViewController(detailVC, animated: true)
            } else if indexPath.row == 1 {
                let detailVC = AttributionsViewController()
                detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = actionSheet.buttonTitleAtIndex(buttonIndex)
        if buttonTitle == I18N.localizedString("CANCEL") {
            return
        }
        
        if actionSheet.title == I18N.localizedString("SETTINGS_LANG_PROMPT") {
            if buttonTitle == "English" {
                I18N.setLanguage("en")
            } else if buttonTitle == "繁體中文" {
                I18N.setLanguage("zh-Hant")
            } else if buttonTitle == "简体中文" {
                I18N.setLanguage("zh-Hans")
            } else if buttonTitle == "日本語" {
                I18N.setLanguage("ja")
            }
            self.navigationItem.title = I18N.localizedString("SETTINGS_TITLE")
            self.tableView.reloadData()
            setFooter()
        } else if actionSheet.title == I18N.localizedString("SETTINGS_SIGNOUT_PROMPT") {
            if buttonTitle == I18N.localizedString("NORMALCASE_SIGN_OUT") {
                AccountUtils.removeUsername()
                AccountUtils.removePassword()
                setFooter()
            }
        }
    }

}

//
//  MyMailViewController.swift
//  Purdue
//
//  Created by George Lo on 9/30/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class MyMailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    let viewController = SignInViewController()
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: "signInSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: "signInFail", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func receivedNotification(notification: NSNotification) {
        if notification.name == "signInSuccess" {
            println("S")
        } else if notification.name == "signInFail" {
            println("F")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MyMail"
        
        if AccountUtils.getUsername() == nil || AccountUtils.getPassword() == nil {
            let defaultHeight = CGFloat(20 + 64) // StatusBar + NavigationBar
            
            let oopsLabel = UILabel(frame: CGRectMake(0, defaultHeight + UIScreen.mainScreen().bounds.height / 10 * 0.5, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 10 * 1.5))
            oopsLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
            oopsLabel.textAlignment = NSTextAlignment.Center
            oopsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 60)
            oopsLabel.text = "Oops!"
            self.view.addSubview(oopsLabel)
            
            let hintLabel = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height / 10 * 2.25 + defaultHeight, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 10 * 1.5))
            hintLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
            hintLabel.textAlignment = NSTextAlignment.Center
            hintLabel.font = UIFont(name: "ArialRoundedMTBold", size: 24)
            hintLabel.numberOfLines = 2
            hintLabel.text = "Please sign in by\ntapping the button below"
            self.view.addSubview(hintLabel)
            
            let btnHeight = CGFloat(60)
            let signInBtn = BButton(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 160) / 2, UIScreen.mainScreen().bounds.height * 0.425 + defaultHeight, 160, btnHeight), type: BButtonType.Success, style: BButtonStyle.BootstrapV3)
            signInBtn.setTitle("Sign In", forState: UIControlState.Normal)
            signInBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
            signInBtn.addTarget(self, action: "showSignIn", forControlEvents: UIControlEvents.TouchUpInside)
            signInBtn.buttonCornerRadius = 7.5
            self.view.addSubview(signInBtn)
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopup")
            gestureRecognizer.delegate = self
            self.view.addGestureRecognizer(gestureRecognizer)
        } else {
            setupTableView()
        }
    }
    
    func dismissPopup() {
        self.navigationItem.leftBarButtonItem?.enabled = true
        (UIApplication.sharedApplication().delegate as AppDelegate).slidingViewController?.dismissPopupViewControllerAnimated(true, completion: nil)
    }
    
    func showSignIn() {
        self.navigationItem.leftBarButtonItem?.enabled = false
        (UIApplication.sharedApplication().delegate as AppDelegate).slidingViewController?.presentPopupViewController(viewController, animated: true, completion: nil)
    }
    
    func setupTableView() {
        let tableView = UITableView(frame: CGRectZero)
        tableView.dataSource = self
        tableView.delegate = self
        self.view = tableView
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view != viewController.view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        
        return cell
    }
}

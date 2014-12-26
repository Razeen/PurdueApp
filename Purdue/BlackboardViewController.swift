//
//  BlackboardViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class BlackboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var signInBtn: BButton?
    var viewController: UIViewController?
    let progress = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30 ) / 2, 84 + 20, 30, 30))
    var courses: [Course] = []
    
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
            loadCourses()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Blackboard"
        viewController = SignInViewController(source: (UIApplication.sharedApplication().delegate as AppDelegate).slidingViewController!)
        
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
            signInBtn = BButton(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 160) / 2, UIScreen.mainScreen().bounds.height * 0.425 + defaultHeight, 160, btnHeight), type: BButtonType.Success, style: BButtonStyle.BootstrapV3)
            signInBtn!.setTitle("Sign In", forState: UIControlState.Normal)
            signInBtn!.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
            signInBtn!.addTarget(self, action: "showSignIn", forControlEvents: UIControlEvents.TouchUpInside)
            signInBtn!.buttonCornerRadius = 7.5
            self.view.addSubview(signInBtn!)
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopup")
            gestureRecognizer.delegate = self
            self.view.addGestureRecognizer(gestureRecognizer)
        } else {
            loadCourses()
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
    
    func loadCourses() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.view.addSubview(progress)
        progress.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Getting SessionID 1 and 2
            var postString = NSString(format: "username=%@&password=%@", AccountUtils.getUsername()!, AccountUtils.getPassword()!)
            var request = NSMutableURLRequest(URL: NSURL(string: "https://mycourses.purdue.edu/webapps/Bb-mobile-BBLEARN/sslUserLogin?v=2&f=xml&ver=4.1.2&registration_id=11946")!)
            request.HTTPMethod = "POST"
            request.setValue("\(postString.length)", forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            
            // Getting SessionID 3 and 4
            var str = NSString(contentsOfURL: NSURL(string: "https://mycourses.purdue.edu/webapps/Bb-mobile-BBLEARN/ping?v=1&f=xml&ver=4.1.2&registration_id=11946&")!, encoding: NSUTF8StringEncoding, error: nil)
            
            // Getting Courses
            var err: NSError?
            let dict = XMLReader.dictionaryForXMLData(NSData(contentsOfURL: NSURL(string: "https://mycourses.purdue.edu/webapps/Bb-mobile-BBLEARN/enrollments?v=1&f=xml&ver=4.1.2&registration_id=11946&course_type=ALL&include_grades=false")!), error: &err) as NSDictionary!
            let courses = ((dict["mobileresponse"] as NSDictionary)["courses"] as NSDictionary)["course"] as [NSDictionary]
            for currCourse in courses {
                let course = Course()
                course.name = currCourse["name"] as NSString!
                course.id = currCourse["bbid"] as NSString!
                self.courses.append(course)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.progress.stopAnimating()
                self.progress.removeFromSuperview()
                let tableView = UITableView(frame: CGRectZero)
                tableView.rowHeight = 60
                tableView.dataSource = self
                tableView.delegate = self
                self.view = tableView
            })
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
        return courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        cell?.textLabel?.text = courses[indexPath.row].name!
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = BlackboardCourseViewController()
        viewController.navigationItem.title = courses[indexPath.row].name
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        viewController.courseid = courses[indexPath.row].id
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//
//  AppDelegate.swift
//  Purdue
//
//  Created by George Lo on 9/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDelegate {

    var window: UIWindow?
    var slidingViewController: ECSlidingViewController?
    let sideMenuVC : SideMenuViewController = SideMenuViewController()
    var topViewSnapshot: UIView?
    
    var rowNames: [String]?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let currentVersionString = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")! as NSString
        let currentVersion = (currentVersionString.stringByReplacingOccurrencesOfString(".", withString: "") as NSString).integerValue
        if NSUserDefaults.standardUserDefaults().integerForKey("AppVersion") == 200 { // If upgraded from version 2.0.0
            
        }
        NSUserDefaults.standardUserDefaults().setInteger(currentVersion, forKey: "AppVersion")
        
        let viewController = MenuViewController()
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "SideMenu"), style: UIBarButtonItemStyle.Done, target: self, action: "showMenu")
        let navigationController: UINavigationController = AppDelegate.createNavController(viewController)
        slidingViewController = ECSlidingViewController(topViewController: navigationController)
        
        sideMenuVC.tableView.delegate = self
        slidingViewController?.underLeftViewController = sideMenuVC
        slidingViewController?.anchorLeftRevealAmount = 250.0;
        
        window?.rootViewController = slidingViewController
        window?.makeKeyAndVisible()
        return true
    }
    
    class func createNavController(viewController: UIViewController) -> UINavigationController {
        let navigationController: UINavigationController = UINavigationController(navigationBarClass: PUNavigationBar.self, toolbarClass: nil)
        navigationController.viewControllers = [viewController]
        navigationController.view.backgroundColor = UIColor.whiteColor()
        navigationController.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: CGFloat(25))!]
        navigationController.view.layer.shadowOpacity = 0.95
        navigationController.view.layer.shadowRadius = 20.0
        navigationController.view.layer.shadowColor = UIColor.blackColor().CGColor
        return navigationController
    }
    
    func showMenu() {
        if let view = slidingViewController?.topViewController.view {
            freezeStatusBarToTopView(view)
        }
        slidingViewController?.anchorTopViewToRightAnimated(true)
    }
    
    func closeMenu() {
        removeTopViewSnapshot()
        slidingViewController?.resetTopViewAnimated(true)
    }
    
    func freezeStatusBarToTopView(topView: UIView) {
        topViewSnapshot = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
        topViewSnapshot?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closeMenu"))
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        topView.addSubview(topViewSnapshot!)
    }
    
    func removeTopViewSnapshot() {
        topViewSnapshot?.removeFromSuperview()
        topViewSnapshot = nil
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowNames = sideMenuVC.rowNames
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let realNames = rowNames {
            var navigationController: UINavigationController?
            
            if (realNames[indexPath.row] as NSString).isEqualToString("MyMail") {
                navigationController = AppDelegate.createNavController(MyMailFolderViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString("Blackboard") {
                navigationController = AppDelegate.createNavController(BlackboardViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_SCHEDULE")) {
                let webBrowser = KINWebBrowserViewController.webBrowser()
                webBrowser.navigationItem.title = I18N.localizedString("CALENDAR_TITLE")
                webBrowser.showsURLInNavigationBar = false
                webBrowser.showsPageTitleInNavigationBar = false
                navigationController = AppDelegate.createNavController(webBrowser)
                webBrowser.loadURLString("https://calendar.purdue.edu/")
                //navigationController = AppDelegate.createNavController(ScheduleViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_BUS")) {
                navigationController = AppDelegate.createNavController(BusViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_MAP")) {
                navigationController = AppDelegate.createNavController(MapViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_LABS")) {
                navigationController = AppDelegate.createNavController(LabsViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_GAMES")) {
                let webBrowser = KINWebBrowserViewController.webBrowser()
                webBrowser.navigationItem.title = I18N.localizedString("GAMES_TITLE")
                webBrowser.showsURLInNavigationBar = false
                webBrowser.showsPageTitleInNavigationBar = false
                navigationController = AppDelegate.createNavController(webBrowser)
                webBrowser.loadURLString("http://m.purduesports.com/index-mobile.html")
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_MENU")) {
                navigationController = AppDelegate.createNavController(MenuViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_NEWS")) {
                navigationController = AppDelegate.createNavController(NewsViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_WEATHER")) {
                navigationController = AppDelegate.createNavController(WeatherViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_LIBRARY")) {
                navigationController = AppDelegate.createNavController(LibraryViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_PHOTOS")) {
                navigationController = AppDelegate.createNavController(PhotoViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_VIDEOS")) {
                navigationController = AppDelegate.createNavController(VideoViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(I18N.localizedString("SIDEMENU_DIRECTORY")) {
                navigationController = AppDelegate.createNavController(DirectoryViewController())
            } else {
                let webBrowser = KINWebBrowserViewController.webBrowser()
                webBrowser.navigationItem.title = I18N.localizedString("STORE_TITLE")
                webBrowser.showsURLInNavigationBar = false
                webBrowser.showsPageTitleInNavigationBar = false
                navigationController = AppDelegate.createNavController(webBrowser)
                webBrowser.loadURLString("https://purdue.amazon.com/")
            }
            slidingViewController?.topViewController = navigationController
            (slidingViewController?.topViewController as UINavigationController).viewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "SideMenu"), style: .Done, target: self, action: "showMenu")
            closeMenu()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, 250, 180))
        headerView.backgroundColor = UIColor(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1)
        
        let imageView: UIImageView = UIImageView(image: UIImage(named: "PU_Logo"))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRectMake(30, 50, 210, 80)
        headerView.addSubview(imageView)
        
        let bottomLayer: CALayer = CALayer()
        bottomLayer.frame = CGRectMake(0, 180 - 2, 1000, 2)
        bottomLayer.backgroundColor = UIColor(white: 0.5, alpha: 0.6).CGColor
        headerView.layer.addSublayer(bottomLayer)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, 250, 50))
        footerView.backgroundColor = UIColor(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1)
        
        let settingBtn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        settingBtn.addTarget(self, action: "showSettings", forControlEvents: UIControlEvents.TouchUpInside)
        settingBtn.tintColor = UIColor.whiteColor()
        settingBtn.frame = CGRectMake(0, 2, 48, 48)
        settingBtn.setImage(UIImage(named: "Settings")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        footerView.addSubview(settingBtn)
        
        let copyrightLbl: UILabel = UILabel(frame: CGRectMake(48, 2, 250 - 48, 48))
        copyrightLbl.text = "© PURDUE UNIVERSITY"
        copyrightLbl.textColor = UIColor.whiteColor()
        copyrightLbl.textAlignment = NSTextAlignment.Right
        copyrightLbl.font = UIFont(name: "Avenir-Book", size: 15)
        footerView.addSubview(copyrightLbl)
        
        let upperLayer: CALayer = CALayer()
        upperLayer.frame = CGRectMake(0, 0, 1000, 2)
        upperLayer.backgroundColor = UIColor(white: 0.5, alpha: 0.6).CGColor
        footerView.layer.addSublayer(upperLayer)
        
        return footerView
    }
    
    func showSettings() {
        slidingViewController!.presentViewController(AppDelegate.createNavController(SettingsViewController()), animated: true, completion: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


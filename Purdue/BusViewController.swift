//
//  BusViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class BusViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    let routesButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let stopsButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let mapButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let bookmarksButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var selectedIndex: UInt8 = 0
    
    var routesDict: NSMutableDictionary = NSMutableDictionary()
    var stopsDict: NSMutableDictionary = NSMutableDictionary()
    var routes: [Route] = []
    var stops: [Stop] = []
    var bookmarks: [String] = []
    
    // 0 = Haven't start
    // 1 = Loading
    // 2 = Finished
    var loadState = 0
    
    let routesTV = UITableView(frame: CGRectMake(0, 84, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84 - 44))
    let stopsTV = UITableView(frame: CGRectMake(0, 84, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84 - 44))
    let mapView = MKMapView(frame: CGRectMake(0, 84, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84 - 44))
    let bookmarksTV = UITableView(frame: CGRectMake(0, 84, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84 - 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("BUS_TITLE", comment: "")
        
        routesTV.dataSource = self
        routesTV.delegate = self
        stopsTV.dataSource = self
        stopsTV.delegate = self
        bookmarksTV.dataSource = self
        bookmarksTV.delegate = self
        self.view.addSubview(routesTV)
        self.view.addSubview(stopsTV)
        self.view.addSubview(mapView)
        self.view.addSubview(bookmarksTV)
        
        let separatorLabel = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel.backgroundColor = UIColor.lightGrayColor()
        let separatorLabel2 = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel2.backgroundColor = UIColor.lightGrayColor()
        let separatorLabel3 = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel3.backgroundColor = UIColor.lightGrayColor()
        
        routesButton.setTitle(I18N.localizedString("BUS_ROUTES"), forState: UIControlState.Normal)
        routesButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        routesButton.sizeToFit()
        routesButton.tintColor = UIColor(red: 163.0/255, green: 121.0/255, blue: 44.0/255, alpha: 1)
        routesButton.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        routesButton.layer.shadowOffset = CGSizeZero
        routesButton.layer.shadowOpacity = 0.5
        routesButton.layer.shadowRadius = 5
        routesButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let routesItem = UIBarButtonItem(customView: routesButton)
        
        stopsButton.setTitle(I18N.localizedString("BUS_STOPS"), forState: UIControlState.Normal)
        stopsButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        stopsButton.sizeToFit()
        stopsButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        stopsButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let stopsItem = UIBarButtonItem(customView: stopsButton)
        
        mapButton.setTitle(I18N.localizedString("BUS_MAP"), forState: UIControlState.Normal)
        mapButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        mapButton.sizeToFit()
        mapButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        mapButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let mapItem = UIBarButtonItem(customView: mapButton)
        
        bookmarksButton.setTitle(I18N.localizedString("BUS_BOOKMARKS"), forState: UIControlState.Normal)
        bookmarksButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        bookmarksButton.sizeToFit()
        bookmarksButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        bookmarksButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let bookmarkItem = UIBarButtonItem(customView: bookmarksButton)
        
        let itemsArray = NSMutableArray(array: [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            routesItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: separatorLabel),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            stopsItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: separatorLabel2),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            mapItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: separatorLabel3),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            bookmarkItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            ])
        self.navigationController?.toolbar.translucent = false
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems(itemsArray, animated: false)
    }
    
    func downloadRoutesAndStops() {
        loadState = 1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let routesArray = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSURL(string: "http://citybus.doublemap.com/map/v2/routes")!)!, options: NSJSONReadingOptions.AllowFragments, error: nil) as [NSDictionary]!
            for routesDict in routesArray {
                let currentRoute = Route()
                currentRoute.id = (routesDict["id"] as NSString!).integerValue
                currentRoute.name = routesDict["name"] as String!
                currentRoute.short_name = routesDict["short_name"] as String!
                currentRoute.desc = routesDict["description"] as String!
                currentRoute.color = self.UIColorFromRGBString(routesDict["color"] as String!)
                var coordinates: [CLLocationCoordinate2D] = []
                let paths = routesDict["path"] as [Double]
                for (var i = 0; i < paths.count; i += 2) {
                    coordinates.append(CLLocationCoordinate2DMake(paths[i], paths[i + 1]))
                }
                currentRoute.path = coordinates
                self.routesDict.setObject(currentRoute, forKey: currentRoute.short_name!)
            }
            
            let stopsArray = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSURL(string: "http://citybus.doublemap.com/map/v2/stops")!)!, options: NSJSONReadingOptions.AllowFragments, error: nil) as [NSDictionary]
            for stopsDict in stopsArray {
                let currentStop = Stop()
                currentStop.id = (stopsDict["id"] as NSString!).integerValue
                currentStop.name = stopsDict["name"] as String!
                currentStop.desc = stopsDict["description"] as String!
                currentStop.desc = currentStop.desc!.stringByReplacingOccurrencesOfString("\\\"", withString: "") as String!
                currentStop.coordinate = CLLocationCoordinate2DMake(stopsDict["lat"] as Double, stopsDict["lon"] as Double)
                self.stopsDict.setObject(currentStop, forKey: NSValue(MKCoordinate: currentStop.coordinate!))
            }
            
            NSUserDefaults.standardUserDefaults().setObject(self.routesDict, forKey: "Bus_Routes") // [Route]
            NSUserDefaults.standardUserDefaults().setObject(self.stopsDict, forKey: "Bus_Stops") // [Stop]
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.loadState = 2
        })
    }
    
    func loadRoutesAndStops() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            self.routesDict = NSUserDefaults.standardUserDefaults().objectForKey("Bus_Routes") as NSMutableDictionary
            self.stopsDict = NSUserDefaults.standardUserDefaults().objectForKey("Bus_Stops") as NSMutableDictionary
            
            var tempRoutes = NSMutableArray()
            for routeKey in self.routesDict.allKeys as [NSString] {
                tempRoutes.addObject(self.routesDict[routeKey] as Route!)
            }
            
            var tempStops = NSMutableArray()
            for stopKey in self.stopsDict.allKeys as [NSString] {
                tempStops.addObject(self.stopsDict[stopKey] as Stop!)
            }
            
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            self.routes = tempRoutes.sortedArrayUsingDescriptors([sortDescriptor]) as [Route]
            self.stops = tempStops.sortedArrayUsingDescriptors([sortDescriptor]) as [Stop]
            self.reloadViews()
        })
        
    }
    
    func reloadViews() {
        dispatch_async(dispatch_get_main_queue(), {
            self.routesTV.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            self.stopsTV.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            // Reload MapView and Bookmark
        })
        
    }
    
    func UIColorFromRGBString(colorString: String) -> UIColor {
        var hexValue: CUnsignedLongLong = 0
        NSScanner(string: colorString).scanHexLongLong(&hexValue)
        return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexValue & 0x0000FF) / 255.0,
            alpha: 1.0)
    }
    
    func changedTab(sender: UIButton) {
        routesButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        routesButton.layer.shadowRadius = 0
        stopsButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        stopsButton.layer.shadowRadius = 0
        mapButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        mapButton.layer.shadowRadius = 0
        bookmarksButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        bookmarksButton.layer.shadowRadius = 0
        
        sender.tintColor = ColorUtils.Legacy.OldGold
        sender.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        sender.layer.shadowOffset = CGSizeZero
        sender.layer.shadowOpacity = 0.5
        sender.layer.shadowRadius = 5
        
        if sender == routesButton {
            selectedIndex = 0
            self.view.bringSubviewToFront(routesTV)
        } else if sender == stopsButton {
            selectedIndex = 1
            self.view.bringSubviewToFront(stopsTV)
        } else if sender == mapButton {
            selectedIndex = 2
            self.view.bringSubviewToFront(mapView)
        } else if sender == bookmarksButton {
            selectedIndex = 3
            self.view.bringSubviewToFront(bookmarksTV)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == routesTV {
            return routes.count
        } else if tableView == stopsTV {
            return stops.count
        } else if tableView == bookmarksTV {
            return bookmarks.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == routesTV {
            
        } else if tableView == stopsTV {
            
        } else if tableView == bookmarksTV {
            
        }
        return UITableViewCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

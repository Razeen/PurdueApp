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
    
    var routesDict = NSMutableDictionary()
    var stopsDict = NSMutableDictionary()
    var routes = NSMutableArray()
    var stops = NSMutableArray()
    var bookmarks = NSUserDefaults.standardUserDefaults().objectForKey("Bus_Bookmarks") as NSMutableArray
    
    let routesTV = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84 - 44))
    let stopsTV = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84 - 44))
    let mapView = MKMapView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84 - 44))
    let bookmarksTV = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84 - 44))
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
        bookmarks = NSUserDefaults.standardUserDefaults().objectForKey("Bus_Bookmarks") as NSMutableArray
        self.bookmarksTV.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("BUS_TITLE", comment: "")
        if NSUserDefaults.standardUserDefaults().objectForKey("Bus_Bookmarks") == nil {
            NSUserDefaults.standardUserDefaults().setObject(NSMutableArray(), forKey: "Bus_Bookmarks")
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("Bus_Routes") == nil || NSUserDefaults.standardUserDefaults().objectForKey("Bus_Stops") == nil {
            let ScreenWidth = UIScreen.mainScreen().bounds.width
            let ScreenHeight = UIScreen.mainScreen().bounds.height
            let activityIndicatorView = MRActivityIndicatorView(frame: CGRectMake((ScreenWidth - 30) / 2, (ScreenHeight - 30) / 2, 30, 30))
            activityIndicatorView.tintColor = ColorUtils.Legacy.OldGold
            self.view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            downloadRoutesAndStops({
                dispatch_async(dispatch_get_main_queue(), {
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.removeFromSuperview()
                    self.setupViews()
                    self.loadRoutesAndStops()
                })
            })
        } else {
            self.setupViews()
            self.loadRoutesAndStops()
        }
    }
    
    func setupViews() {
        self.routesTV.dataSource = self
        self.routesTV.delegate = self
        self.routesTV.rowHeight = 50
        self.stopsTV.dataSource = self
        self.stopsTV.delegate = self
        self.stopsTV.rowHeight = 50
        self.bookmarksTV.dataSource = self
        self.bookmarksTV.delegate = self
        self.bookmarksTV.rowHeight = 50
        self.view.addSubview(self.routesTV)
        self.view.addSubview(self.stopsTV)
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.bookmarksTV)
        self.view.bringSubviewToFront(self.routesTV)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let separatorLabel = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel.backgroundColor = UIColor.lightGrayColor()
        let separatorLabel2 = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel2.backgroundColor = UIColor.lightGrayColor()
        let separatorLabel3 = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel3.backgroundColor = UIColor.lightGrayColor()
        
        self.routesButton.setTitle(I18N.localizedString("BUS_ROUTES"), forState: UIControlState.Normal)
        self.routesButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.routesButton.sizeToFit()
        self.routesButton.tintColor = UIColor(red: 163.0/255, green: 121.0/255, blue: 44.0/255, alpha: 1)
        self.routesButton.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        self.routesButton.layer.shadowOffset = CGSizeZero
        self.routesButton.layer.shadowOpacity = 0.5
        self.routesButton.layer.shadowRadius = 5
        self.routesButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let routesItem = UIBarButtonItem(customView: self.routesButton)
        
        self.stopsButton.setTitle(I18N.localizedString("BUS_STOPS"), forState: UIControlState.Normal)
        self.stopsButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.stopsButton.sizeToFit()
        self.stopsButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        self.stopsButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let stopsItem = UIBarButtonItem(customView: self.stopsButton)
        
        self.mapButton.setTitle(I18N.localizedString("BUS_MAP"), forState: UIControlState.Normal)
        self.mapButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.mapButton.sizeToFit()
        self.mapButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        self.mapButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let mapItem = UIBarButtonItem(customView: self.mapButton)
        
        self.bookmarksButton.setTitle(I18N.localizedString("BUS_BOOKMARKS"), forState: UIControlState.Normal)
        self.bookmarksButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.bookmarksButton.sizeToFit()
        self.bookmarksButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        self.bookmarksButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let bookmarkItem = UIBarButtonItem(customView: self.bookmarksButton)
        
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
    
    func drawRouteImage(color: UIColor, text: NSString) -> UIImage {
        let len: CGFloat = 34
        
        // Draw the Circle
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(len, len), false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillEllipseInRect(context, CGRectMake(0, 0, len, len))
        
        // Draw the Text
        let paraStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        paraStyle.alignment = NSTextAlignment.Center
        let fontAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(17),
            NSParagraphStyleAttributeName: paraStyle,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        text.drawInRect(CGRectMake(0, 7, len, 22), withAttributes: fontAttributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func downloadRoutesAndStops(completion: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let routesArray = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSURL(string: "https://citybus.doublemap.com/map/v2/routes")!)!, options: NSJSONReadingOptions.AllowFragments, error: nil) as [NSDictionary]!
            for routesDict in routesArray {
                /**
                
                    RoutesDict <RouteId, Route> for constant time mapping in Routes and Stops tab
                    - Time Complexity: O(1)
                    - Space Complexity: O(n)
                
                */
                let currentRoute = Route()
                currentRoute.id = routesDict["id"] as NSInteger
                let nameAry = NSMutableArray(array: (routesDict["name"] as NSString!).componentsSeparatedByString(" "))
                nameAry.removeObjectAtIndex(0)
                currentRoute.name = nameAry.componentsJoinedByString(" ")
                currentRoute.short_name = routesDict["short_name"] as NSString!
                currentRoute.desc = routesDict["description"] as NSString!
                currentRoute.color = self.UIColorFromRGBString(routesDict["color"] as NSString!)
                currentRoute.image = self.drawRouteImage(currentRoute.color!, text: currentRoute.short_name!)
                let coordinates: NSMutableArray = NSMutableArray()
                let paths = routesDict["path"] as [Double]
                for (var i = 0; i < paths.count; i += 2) {
                    let coordinate = CLLocation(latitude: paths[i] as Double, longitude: paths[i + 1] as Double)
                    coordinates.addObject(coordinate)
                }
                
                let stopsArray = NSMutableArray(array: routesDict["stops"] as NSArray!)
                let temp: NSArray = routesDict["stops"] as NSArray!
                var index = temp.count - 1
                for object in temp.reverseObjectEnumerator().allObjects {
                    if stopsArray.indexOfObject(object, inRange: NSMakeRange(0, index)) != NSNotFound {
                        stopsArray.removeObjectAtIndex(index)
                    }
                    index--
                }
                currentRoute.stops = stopsArray
                currentRoute.path = coordinates
                self.routesDict.setObject(currentRoute, forKey: NSNumber(integer: currentRoute.id))
            }
            
            let stopsArray = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSURL(string: "https://citybus.doublemap.com/map/v2/stops")!)!, options: NSJSONReadingOptions.AllowFragments, error: nil) as [NSDictionary]
            for stopsDict in stopsArray {
                /**
                    
                    StopsDict <StopId, Stop> for constant time mapping in Routes and Stops tab
                    - Time Complexity: O(1)
                    - Space Complexity: O(n)
                
                */
                if self.stopsDict[NSNumber(integer: stopsDict["id"] as NSInteger)] == nil {
                    let currentStop = Stop()
                    currentStop.id = stopsDict["id"] as NSInteger
                    currentStop.idArray.append(stopsDict["id"] as NSInteger)
                    currentStop.name = (stopsDict["name"] as NSString!).componentsSeparatedByString("-")[0] as? NSString
                    if currentStop.name!.substringFromIndex(currentStop.name!.length - 1) == " " {
                        currentStop.name = currentStop.name!.substringToIndex(currentStop.name!.length - 1)
                    }
                    currentStop.coordinate = CLLocationCoordinate2DMake(stopsDict["lat"] as Double, stopsDict["lon"] as Double)
                    self.stopsDict.setObject(currentStop, forKey: NSNumber(integer: stopsDict["id"] as NSInteger))
                } else {
                    let savedStop = self.stopsDict[NSNumber(integer: stopsDict["id"] as NSInteger)] as Stop!
                    savedStop.idArray.append(stopsDict["id"] as NSInteger)
                    self.stopsDict.setObject(savedStop, forKey: NSNumber(integer: stopsDict["id"] as NSInteger))
                }
            }
            
            let encodedRoutes = NSKeyedArchiver.archivedDataWithRootObject(self.routesDict)
            NSUserDefaults.standardUserDefaults().setObject(encodedRoutes, forKey: "Bus_Routes") // [Route]
            let encodedStops = NSKeyedArchiver.archivedDataWithRootObject(self.stopsDict)
            NSUserDefaults.standardUserDefaults().setObject(encodedStops, forKey: "Bus_Stops") // [Stop]
            NSUserDefaults.standardUserDefaults().synchronize()
            
            completion()
        })
    }
    
    func loadRoutesAndStops() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let decodedRoutes = NSUserDefaults.standardUserDefaults().objectForKey("Bus_Routes") as NSData
            self.routesDict = NSKeyedUnarchiver.unarchiveObjectWithData(decodedRoutes) as NSMutableDictionary
            let decodedStops = NSUserDefaults.standardUserDefaults().objectForKey("Bus_Stops") as NSData
            self.stopsDict = NSKeyedUnarchiver.unarchiveObjectWithData(decodedStops) as NSMutableDictionary
            
            for routeKey in self.routesDict.allKeys as [NSNumber] {
                self.routes.addObject(self.routesDict[routeKey] as Route!)
            }
            
            for stopKey in self.stopsDict.allKeys as [NSNumber] {
                self.stops.addObject(self.stopsDict[stopKey] as Stop!)
            }
            
            self.routes.sortUsingComparator({
                (temp1, temp2) -> NSComparisonResult in
                let r1: Route = temp1 as Route
                let r2: Route = temp2 as Route
                return r1.short_name!.compare(r2.short_name!, options: NSStringCompareOptions.NumericSearch)
            })
            self.stops.sortUsingDescriptors([NSSortDescriptor(key: "id", ascending: true)])
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
        let CellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        if tableView == routesTV {
            let route = routes[indexPath.row] as Route
            cell?.imageView?.image = route.image
            cell?.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
            cell?.textLabel?.text = route.name
        } else if tableView == stopsTV {
            let stop = stops[indexPath.row] as Stop
            cell?.imageView?.image = UIImage(named: "Stop")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell?.imageView?.tintColor = ColorUtils.Cool.DarkBlue
            cell?.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
            cell?.textLabel?.numberOfLines = 2
            cell?.textLabel?.text = stop.name
        } else if tableView == bookmarksTV {
            let bookmark = bookmarks[indexPath.row] as NSString
            cell?.imageView?.image = UIImage(named: "Bookmark")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell?.imageView?.tintColor = ColorUtils.Core.Brown
            cell?.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
            cell?.textLabel?.numberOfLines = 2
            cell?.textLabel?.text = bookmark
        }
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == routesTV {
            let detailVC = RouteDetailViewController()
            detailVC.route = routes[indexPath.row] as? Route
            detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else if tableView == stopsTV {
            let detailVC = StopDetailViewController()
            detailVC.stop = stops[indexPath.row] as? Stop
            detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else if tableView == bookmarksTV {
            let bookmarkName = bookmarks[indexPath.row] as NSString
            for stop in stops {
                if stop.name == bookmarkName {
                    let detailVC = StopDetailViewController()
                    detailVC.stop = stop as? Stop
                    detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
                    self.navigationController?.pushViewController(detailVC, animated: true)
                    break
                }
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

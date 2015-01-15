//
//  DiningCourtViewController.swift
//  Purdue
//
//  Created by George Lo on 1/7/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

class DiningCourtDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let menuButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let infoButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let hoursButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    
    let menuView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    let infoView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    let hoursView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    
    var diningCourtInfo: NSDictionary = NSDictionary()
    var hours: [[NSDictionary]] = []
    
    var meals: [NSDictionary] = []
    let dateLabel = UILabel(frame: CGRectMake(40, 0, UIScreen.mainScreen().bounds.width - 80, 60))
    var foodArray: [[NSDictionary]] = [] // Store all the food for each period (Breakfast, Lunch, Late Lunch, Dinner)
    
    var currentDate: NSDate = NSDate()
    let activityIndicatorView = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30) / 2, 60 + 15, 30, 30))
    let dayInterval = NSTimeInterval(60*60*24)
    
    let indexDayDict: NSDictionary = [
        0: "SUNDAY",
        1: "MONDAY",
        2: "TUESDAY",
        3: "WEDNESDAY",
        4: "THURSDAY",
        5: "FRIDAY",
        6: "SATURDAY"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempDays = ((diningCourtInfo["NormalHours"] as NSArray)[0] as NSDictionary)["Days"] as NSArray
        let sortedDays = tempDays.sortedArrayUsingDescriptors([NSSortDescriptor(key: "DayOfWeek", ascending: true)]) as [NSDictionary]
        for sortedDay in sortedDays {
            let tempMeals = sortedDay["Meals"] as NSArray
            hours.append(tempMeals.sortedArrayUsingDescriptors([NSSortDescriptor(key: "Order", ascending: true)]) as [NSDictionary])
        }
        
        self.navigationItem.title = diningCourtInfo["Name"] as? String
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Directions"), style: UIBarButtonItemStyle.Done, target: self, action: "showDirections")
        self.navigationItem.rightBarButtonItem?.tintColor = ColorUtils.Core.Brown
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let menuPanel = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 60))
        let darkLine = UIView(frame: CGRectMake(0, 59, UIScreen.mainScreen().bounds.width, 1))
        darkLine.backgroundColor = self.menuView.separatorColor
        menuPanel.addSubview(darkLine)
        
        let leftButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        leftButton.frame = CGRectMake(20, 10, 20, 40)
        leftButton.setImage(UIImage(named: "Left"), forState: UIControlState.Normal)
        leftButton.tintColor = UIColor.blackColor()
        leftButton.addTarget(self, action: "showPrevDayMenu", forControlEvents: UIControlEvents.TouchUpInside)
        menuPanel.addSubview(leftButton)
        
        self.dateLabel.font = UIFont(name: "Avenir-Heavy", size: 19)
        self.dateLabel.text = I18N.localizedString("TODAY")
        self.dateLabel.textAlignment = NSTextAlignment.Center
        self.dateLabel.textColor = ColorUtils.Cool.DarkBlue
        menuPanel.addSubview(self.dateLabel)
        
        activityIndicatorView.tintColor = ColorUtils.Legacy.OldGold
        activityIndicatorView.startAnimating()
        self.menuView.addSubview(activityIndicatorView)
        
        let rightButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        rightButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 40, 10, 20, 40)
        rightButton.setImage(UIImage(named: "Right"), forState: UIControlState.Normal)
        rightButton.tintColor = UIColor.blackColor()
        rightButton.addTarget(self, action: "showNextDayMenu", forControlEvents: UIControlEvents.TouchUpInside)
        menuPanel.addSubview(rightButton)
        
        self.menuView.rowHeight = 60
        self.menuView.tableHeaderView = menuPanel
        self.menuView.addSubview(menuPanel)
        self.menuView.dataSource = self
        self.menuView.delegate = self
        self.view.addSubview(self.menuView)
        
        let mapView = MKMapView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 0.3))
        let coordinate = CLLocationCoordinate2DMake(diningCourtInfo["Latitude"] as Double, diningCourtInfo["Longitude"] as Double)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 500, 500), animated: false)
        let annotation = MKPointAnnotation()
        annotation.title = diningCourtInfo["FormalName"] as String
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        self.infoView.tableHeaderView = mapView
        self.infoView.dataSource = self
        self.infoView.delegate = self
        self.view.addSubview(self.infoView)
        
        self.hoursView.dataSource = self
        self.hoursView.delegate = self
        self.view.addSubview(self.hoursView)
        
        self.view.bringSubviewToFront(self.menuView)
        
        let separatorLabel = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel.backgroundColor = UIColor.lightGrayColor()
        let separatorLabel2 = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel2.backgroundColor = UIColor.lightGrayColor()
        
        self.menuButton.setTitle(I18N.localizedString("MENU"), forState: UIControlState.Normal)
        self.menuButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.menuButton.sizeToFit()
        self.menuButton.tintColor = UIColor(red: 163.0/255, green: 121.0/255, blue: 44.0/255, alpha: 1)
        self.menuButton.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        self.menuButton.layer.shadowOffset = CGSizeZero
        self.menuButton.layer.shadowOpacity = 0.5
        self.menuButton.layer.shadowRadius = 5
        self.menuButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let menuItem = UIBarButtonItem(customView: self.menuButton)
        
        self.infoButton.setTitle(I18N.localizedString("INFO"), forState: UIControlState.Normal)
        self.infoButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.infoButton.sizeToFit()
        self.infoButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        self.infoButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let infoItem = UIBarButtonItem(customView: self.infoButton)
        
        self.hoursButton.setTitle(I18N.localizedString("HOURS"), forState: UIControlState.Normal)
        self.hoursButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.hoursButton.sizeToFit()
        self.hoursButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        self.hoursButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let hoursItem = UIBarButtonItem(customView: self.hoursButton)
        
        let itemsArray = NSMutableArray(array: [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            menuItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: separatorLabel),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            infoItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: separatorLabel2),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            hoursItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        ])
        
        self.navigationController?.toolbar.translucent = false
        self.navigationController?.toolbarHidden = false
        self.setToolbarItems(itemsArray, animated: false)
        
        loadMenu()
    }
    
    func showPrevDayMenu() {
        self.meals.removeAll(keepCapacity: false)
        self.foodArray.removeAll(keepCapacity: false)
        self.menuView.reloadData()
        activityIndicatorView.alpha = 1
        self.currentDate = self.currentDate.dateByAddingTimeInterval(-dayInterval)
        updateDateLabel()
        loadMenu()
    }
    
    func showNextDayMenu() {
        self.meals.removeAll(keepCapacity: false)
        self.foodArray.removeAll(keepCapacity: false)
        self.menuView.reloadData()
        activityIndicatorView.alpha = 1
        self.currentDate = self.currentDate.dateByAddingTimeInterval(dayInterval)
        updateDateLabel()
        loadMenu()
    }
    
    func updateDateLabel() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentString = dateFormatter.stringFromDate(currentDate)
        
        let todayDate = NSDate()
        let todayString = dateFormatter.stringFromDate(todayDate)
        let tomorrowDate = todayDate.dateByAddingTimeInterval(dayInterval)
        let tomorrowString = dateFormatter.stringFromDate(tomorrowDate)
        if currentString == todayString {
            self.dateLabel.text = I18N.localizedString("TODAY")
        } else if currentString == tomorrowString {
            self.dateLabel.text = I18N.localizedString("TOMORROW")
        } else {
            dateFormatter.dateFormat = "EEEE MMM dd"
            self.dateLabel.text = dateFormatter.stringFromDate(currentDate)
        }
        
    }
    
    func loadMenu() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let today = dateFormatter.stringFromDate(self.currentDate) as NSString
            let data = NSData(contentsOfURL: NSURL(string: "https://api.hfs.purdue.edu/menus/v2/locations/\(self.navigationItem.title!)/\(today)")!)
            let dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            self.meals = dict["Meals"] as [NSDictionary]
            for meal in self.meals {
                var allFoodForPeriod: [NSDictionary] = []
                for station in meal["Stations"] as [NSDictionary] {
                    let stationName = station["Name"] as String
                    for item in station["Items"] as [NSDictionary] {
                        let mutableItem = item.mutableCopy() as NSMutableDictionary
                        mutableItem.setObject(stationName, forKey: "StationName")
                        allFoodForPeriod.append(mutableItem)
                    }
                }
                self.foodArray.append(allFoodForPeriod)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicatorView.alpha = 0
                self.menuView.reloadData()
            })
        })
    }
    
    func showDirections() {
        let lat = diningCourtInfo["Latitude"] as Double
        let lon = diningCourtInfo["Longitude"] as Double
        let urlString = "http://maps.apple.com/?daddr=\(lat),\(lon)"
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
    }
    
    func changedTab(sender: UIButton) {
        menuButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        menuButton.layer.shadowRadius = 0
        infoButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        infoButton.layer.shadowRadius = 0
        hoursButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        hoursButton.layer.shadowRadius = 0
        
        sender.tintColor = ColorUtils.Legacy.OldGold
        sender.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        sender.layer.shadowOffset = CGSizeZero
        sender.layer.shadowOpacity = 0.5
        sender.layer.shadowRadius = 5
        
        if sender == menuButton {
            self.view.bringSubviewToFront(menuView)
        } else if sender == infoButton {
            self.view.bringSubviewToFront(infoView)
        } else if sender == hoursButton {
            self.view.bringSubviewToFront(hoursView)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == menuView {
            return meals.count
        } else if tableView == infoView {
            return 1
        } else if tableView == hoursView {
            return 7
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuView {
            return foodArray[section].count
        } else if tableView == infoView {
            return 3
        } else if tableView == hoursView {
            return hours[section].count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MenuIdentifier = "MenuIdentifier"
        let InfoIdentifier = "InfoIdentifier"
        let HoursIdentifier = "HoursIdentifier"
        
        var cell: UITableViewCell?
        if tableView == menuView {
            cell = tableView.dequeueReusableCellWithIdentifier(MenuIdentifier) as? UITableViewCell
        } else if tableView == infoView {
            cell = tableView.dequeueReusableCellWithIdentifier(InfoIdentifier) as? UITableViewCell
        } else if tableView == hoursView {
            cell = tableView.dequeueReusableCellWithIdentifier(HoursIdentifier) as? UITableViewCell
        }
        if cell == nil {
            if tableView == menuView {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: MenuIdentifier)
            } else if tableView == infoView {
                cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: InfoIdentifier)
            } else if tableView == hoursView {
                cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: HoursIdentifier)
            }
        }
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 17)
        cell?.detailTextLabel?.font = UIFont(name: "Avenir", size: 14)
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.accessoryView = nil
        
        if tableView == menuView {
            cell?.textLabel?.textColor = UIColor.blackColor()
            cell?.textLabel?.text = foodArray[indexPath.section][indexPath.row]["Name"] as? String
            cell?.detailTextLabel?.text = foodArray[indexPath.section][indexPath.row]["StationName"] as? String
            if foodArray[indexPath.section][indexPath.row]["IsVegetarian"] as Int == 1 {
                let imageView = UIImageView(image: UIImage(named: "Vegetarian")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
                imageView.frame = CGRectMake(0, 0, 25, 25)
                imageView.tintColor = UIColor(red: 102.0/255, green: 204.0/255, blue: 0, alpha: 1)
                cell?.accessoryView = imageView
            }
        } else if tableView == infoView {
            cell?.textLabel?.textColor = ColorUtils.Cool.DarkBlue
            if indexPath.row == 0 {
                cell?.textLabel?.text = I18N.localizedString("NAME")
                cell?.detailTextLabel?.text = diningCourtInfo["FormalName"] as? String
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = I18N.localizedString("PHONE")
                cell?.detailTextLabel?.text = diningCourtInfo["PhoneNumber"] as? String
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = I18N.localizedString("ADDRESS")
                let addressDict = diningCourtInfo["Address"] as NSDictionary!
                let street = addressDict["Street"] as String
                let city = addressDict["City"] as String
                let state = addressDict["State"] as String
                let zipCode = addressDict["ZipCode"] as String
                cell?.detailTextLabel?.text = "\(street)\n\(city), \(state) \(zipCode)"
            }
        } else if tableView == hoursView {
            cell?.textLabel?.textColor = ColorUtils.Cool.DarkBlue
            let key = (hours[indexPath.section][indexPath.row]["Name"] as NSString).uppercaseString
            cell?.textLabel?.text = I18N.localizedString(key)
            let hourDict = hours[indexPath.section][indexPath.row]["Hours"] as? NSDictionary
            if hourDict == nil {
                cell?.detailTextLabel?.text = I18N.localizedString("CLOSED")
            } else {
                let oriStartTime = hourDict!["StartTime"] as NSString
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                var date = dateFormatter.dateFromString(oriStartTime)
                dateFormatter.dateFormat = "hh:mm a"
                let startTime = dateFormatter.stringFromDate(date!)
                
                let oriEndTime = hourDict!["EndTime"] as NSString
                dateFormatter.dateFormat = "HH:mm:ss"
                date = dateFormatter.dateFromString(oriEndTime)
                dateFormatter.dateFormat = "hh:mm a"
                let endTime = dateFormatter.stringFromDate(date!)
                
                cell?.detailTextLabel?.text = "\(startTime) ~ \(endTime)"
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30))
        view.backgroundColor = ColorUtils.Legacy.OldGold
        
        let textLabel = UILabel(frame: CGRectMake(15.5, 0, UIScreen.mainScreen().bounds.width - 15.5, 30))
        textLabel.font = UIFont(name: "Avenir", size: 17)
        if tableView == menuView {
            let key = (self.meals[section]["Name"] as NSString).uppercaseString
            textLabel.text = I18N.localizedString(key)
            if foodArray[section].count == 0 {
                let closed = I18N.localizedString("CLOSED")
                textLabel.text = "\(textLabel.text!) (\(closed))"
                let darkLine = UIView(frame: CGRectMake(0, 29.5, UIScreen.mainScreen().bounds.width, 0.5))
                darkLine.backgroundColor = self.menuView.separatorColor
                view.addSubview(darkLine)
            }
        } else if tableView == infoView {
            textLabel.text = I18N.localizedString("GENERAL")
        } else if tableView == hoursView {
            let key = indexDayDict[section] as String!
            textLabel.text = I18N.localizedString(key)
        }
        textLabel.textAlignment = NSTextAlignment.Left
        textLabel.textColor = UIColor.whiteColor()
        view.addSubview(textLabel)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == menuView {
            return 60
        } else if tableView == infoView {
            if indexPath.row == 2 {
                return 67.5
            }
            return 50
        } else if tableView == hoursView {
            return 50
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

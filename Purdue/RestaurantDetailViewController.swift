//
//  RestaurantViewController.swift
//  Purdue
//
//  Created by George Lo on 1/7/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate {
    let infoButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let mapButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let menuButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    
    let tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    let mapView = MKMapView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    let webView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    
    var restaurantInfo: NSDictionary = NSDictionary()
    var days: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = restaurantInfo["Name"] as? String
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Directions"), style: UIBarButtonItemStyle.Done, target: self, action: "showDirections")
        self.navigationItem.rightBarButtonItem?.tintColor = ColorUtils.Core.Brown
        
        self.edgesForExtendedLayout = UIRectEdge.None
        days = (restaurantInfo["NormalHours"] as NSDictionary)["Days"] as [NSDictionary]
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        let coordinate = CLLocationCoordinate2DMake(restaurantInfo["Latitude"] as Double, restaurantInfo["Longitude"] as Double)
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 500, 500), animated: false)
        let annotation = MKPointAnnotation()
        annotation.title = restaurantInfo["Name"] as String
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        self.view.addSubview(self.mapView)
        
        self.view.addSubview(self.webView)
        
        self.view.bringSubviewToFront(self.tableView)
        
        let separatorLabel = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel.backgroundColor = UIColor.lightGrayColor()
        let separatorLabel2 = UILabel(frame: CGRectMake(0, 0, 1, 20))
        separatorLabel2.backgroundColor = UIColor.lightGrayColor()
        
        self.infoButton.setTitle(I18N.localizedString("MENU_DINING_COURTS"), forState: UIControlState.Normal)
        self.infoButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.infoButton.sizeToFit()
        self.infoButton.tintColor = UIColor(red: 163.0/255, green: 121.0/255, blue: 44.0/255, alpha: 1)
        self.infoButton.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        self.infoButton.layer.shadowOffset = CGSizeZero
        self.infoButton.layer.shadowOpacity = 0.5
        self.infoButton.layer.shadowRadius = 5
        self.infoButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let infoItem = UIBarButtonItem(customView: self.infoButton)
        
        self.mapButton.setTitle(I18N.localizedString("MENU_RESTAURANTS"), forState: UIControlState.Normal)
        self.mapButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.mapButton.sizeToFit()
        self.mapButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        self.mapButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let mapItem = UIBarButtonItem(customView: self.mapButton)
        
        self.menuButton.setTitle(I18N.localizedString("MENU_RESTAURANTS"), forState: UIControlState.Normal)
        self.menuButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.menuButton.sizeToFit()
        self.menuButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        self.menuButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let menuItem = UIBarButtonItem(customView: self.menuButton)
        
        let itemsArray = NSMutableArray(array: [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            infoItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: separatorLabel),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            mapItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        ])
        
        if restaurantInfo["MenuUrl"] as? String != nil {
            itemsArray.addObjectsFromArray([
                UIBarButtonItem(customView: separatorLabel2),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
                menuItem,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            ])
            
            let urlString = restaurantInfo["MenuUrl"] as String!
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
            webView.delegate = self
        }
        
        self.navigationController?.toolbar.translucent = false
        self.navigationController?.toolbarHidden = false
        self.setToolbarItems(itemsArray, animated: false)
    }
    
    func showDirections() {
        let lat = restaurantInfo["Latitude"] as Double
        let lon = restaurantInfo["Longitude"] as Double
        let urlString = "http://maps.apple.com/?daddr=\(lat),\(lon)"
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func changedTab(sender: UIButton) {
        infoButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        infoButton.layer.shadowRadius = 0
        mapButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        mapButton.layer.shadowRadius = 0
        
        sender.tintColor = ColorUtils.Legacy.OldGold
        sender.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        sender.layer.shadowOffset = CGSizeZero
        sender.layer.shadowOpacity = 0.5
        sender.layer.shadowRadius = 5
        
        if sender == infoButton {
            self.view.bringSubviewToFront(tableView)
        } else if sender == mapButton {
            self.view.bringSubviewToFront(mapView)
        } else if sender == menuButton {
            self.view.bringSubviewToFront(webView)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return days.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: CellIdentifier)
        }
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 17)
        cell?.textLabel?.textColor = ColorUtils.Cool.DarkBlue
        cell?.detailTextLabel?.font = UIFont(name: "Avenir", size: 17)
        cell?.detailTextLabel?.numberOfLines = 0
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = I18N.localizedString("PHONE")
                cell?.detailTextLabel?.text = restaurantInfo["PhoneNumber"] as? String
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = I18N.localizedString("ADDRESS")
                let addressDict = restaurantInfo["Address"] as NSDictionary!
                let street = addressDict["Street"] as String
                let city = addressDict["City"] as String
                let state = addressDict["State"] as String
                let zipCode = addressDict["ZipCode"] as String
                cell?.detailTextLabel?.text = "\(street)\n\(city), \(state) \(zipCode)"
            }
        } else if indexPath.section == 1 {
            let dayKey = (days[indexPath.row]["Name"] as NSString).uppercaseString
            cell?.textLabel?.text = I18N.localizedString(dayKey)
            let hours = days[indexPath.row]["Hours"] as [NSDictionary]
            var periodString = ""
            for var i = 0; i < hours.count; i++ {
                let period = hours[i]
                
                let oriStartTime = period["StartTime"] as NSString
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                var date = dateFormatter.dateFromString(oriStartTime)
                dateFormatter.dateFormat = "hh:mm a"
                let startTime = dateFormatter.stringFromDate(date!)
                
                let oriEndTime = period["EndTime"] as NSString
                dateFormatter.dateFormat = "HH:mm:ss"
                date = dateFormatter.dateFromString(oriEndTime)
                dateFormatter.dateFormat = "hh:mm a"
                let endTime = dateFormatter.stringFromDate(date!)
                
                periodString = "\(periodString)\(startTime) ~ \(endTime)"
                if i != hours.count - 1 {
                    periodString = "\(periodString)\n"
                }
            }
            cell?.detailTextLabel?.text = periodString
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30))
        view.backgroundColor = ColorUtils.Legacy.OldGold
        
        let textLabel = UILabel(frame: CGRectMake(15.5, 0, UIScreen.mainScreen().bounds.width - 15.5, 30))
        textLabel.font = UIFont(name: "Avenir", size: 17)
        if section == 0 {
            textLabel.text = I18N.localizedString("GENERAL")
        } else if section == 1 {
            textLabel.text = I18N.localizedString("HOURS")
        }
        textLabel.textAlignment = NSTextAlignment.Left
        textLabel.textColor = UIColor.whiteColor()
        view.addSubview(textLabel)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            } else if indexPath.row == 1 {
                return 67.5
            }
        } else if indexPath.section == 1 {
            let hours = days[indexPath.row]["Hours"] as [NSDictionary]
            return 50.0 + 17.5 * CGFloat(hours.count - 1)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

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
    let mapButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    
    let menuView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    let infoView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    let mapView = MKMapView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    
    var diningCourtInfo: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = diningCourtInfo["Name"] as? String
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Directions"), style: UIBarButtonItemStyle.Done, target: self, action: "showDirections")
        self.navigationItem.rightBarButtonItem?.tintColor = ColorUtils.Core.Brown
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.menuView.dataSource = self
        self.menuView.delegate = self
        self.view.addSubview(self.menuView)
        
        self.infoView.dataSource = self
        self.infoView.delegate = self
        self.view.addSubview(self.infoView)
        
        let coordinate = CLLocationCoordinate2DMake(diningCourtInfo["Latitude"] as Double, diningCourtInfo["Longitude"] as Double)
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 500, 500), animated: false)
        let annotation = MKPointAnnotation()
        annotation.title = diningCourtInfo["FormalName"] as String
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        self.view.addSubview(self.mapView)
        
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
        
        self.mapButton.setTitle(I18N.localizedString("MAP_TITLE"), forState: UIControlState.Normal)
        self.mapButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        self.mapButton.sizeToFit()
        self.mapButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        self.mapButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
        let mapItem = UIBarButtonItem(customView: self.mapButton)
        
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
            mapItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        ])
        
        self.navigationController?.toolbar.translucent = false
        self.navigationController?.toolbarHidden = false
        self.setToolbarItems(itemsArray, animated: false)
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
        mapButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        mapButton.layer.shadowRadius = 0
        
        sender.tintColor = ColorUtils.Legacy.OldGold
        sender.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        sender.layer.shadowOffset = CGSizeZero
        sender.layer.shadowOpacity = 0.5
        sender.layer.shadowRadius = 5
        
        if sender == menuButton {
            self.view.bringSubviewToFront(menuView)
        } else if sender == infoButton {
            self.view.bringSubviewToFront(infoView)
        } else if sender == mapButton {
            self.view.bringSubviewToFront(mapView)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == menuView {
            // TODO:
            return 0
        } else if tableView == infoView {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuView {
            // TODO:
            return 0
        } else if tableView == infoView {
            return 3
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MenuIdentifier = "MenuIdentifier"
        let InfoIdentifier = "InfoIdentifier"
        var cell: UITableViewCell?
        if tableView == menuView {
            cell = tableView.dequeueReusableCellWithIdentifier(MenuIdentifier) as? UITableViewCell
        } else if tableView == infoView {
            cell = tableView.dequeueReusableCellWithIdentifier(InfoIdentifier) as? UITableViewCell
        }
        if cell == nil {
            if tableView == menuView {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: MenuIdentifier)
            } else if tableView == infoView {
                cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: InfoIdentifier)
            }
        }
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 17)
        cell?.textLabel?.textColor = ColorUtils.Cool.DarkBlue
        cell?.detailTextLabel?.font = UIFont(name: "Avenir", size: 17)
        cell?.detailTextLabel?.numberOfLines = 0
        
        if tableView == infoView {
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
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30))
        view.backgroundColor = ColorUtils.Legacy.OldGold
        
        let textLabel = UILabel(frame: CGRectMake(15.5, 0, UIScreen.mainScreen().bounds.width - 15.5, 30))
        textLabel.font = UIFont(name: "Avenir", size: 17)
        if tableView == infoView {
            textLabel.text = I18N.localizedString("GENERAL")
        }
        textLabel.textAlignment = NSTextAlignment.Left
        textLabel.textColor = UIColor.whiteColor()
        view.addSubview(textLabel)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == infoView {
            if indexPath.row == 0 {
                return 50
            } else if indexPath.row == 1 {
                return 50
            } else if indexPath.row == 2 {
                return 67.5
            }
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

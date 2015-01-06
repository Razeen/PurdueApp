//
//  StopViewController.swift
//  Purdue
//
//  Created by George Lo on 1/4/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class StopDetailViewController: UITableViewController {
    
    var stop: Stop?
    var routesDict = NSMutableDictionary()
    
    var routeAry: [NSNumber] = []
    var etaAry: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = stop!.name
        self.tableView.rowHeight = 50
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        // 30%
        let headerView = MKMapView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 0.3))
        let annotation = MKPointAnnotation()
        annotation.title = self.stop!.name
        annotation.coordinate = self.stop!.coordinate
        headerView.addAnnotation(annotation)
        headerView.setRegion(MKCoordinateRegionMakeWithDistance(self.stop!.coordinate, 1000, 1000), animated: false)
        self.tableView.tableHeaderView = headerView
        
        let decodedRoutes = NSUserDefaults.standardUserDefaults().objectForKey("Bus_Routes") as NSData
        self.routesDict = NSKeyedUnarchiver.unarchiveObjectWithData(decodedRoutes) as NSMutableDictionary
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            for stopId in self.stop!.idArray {
                let data = NSData(contentsOfURL: NSURL(string: "http://citybus.doublemap.com/map/v2/eta?stop=\(stopId)")!)!
                if data.length > 2 {
                    let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as NSDictionary
                    for etaDict in ((dict["etas"] as NSDictionary)["\(self.stop!.id)"] as NSDictionary)["etas"] as [NSDictionary] {
                        self.routeAry.append(NSNumber(integer: etaDict["route"] as NSInteger))
                        self.etaAry.append(etaDict["avg"] as NSInteger)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return routeAry.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: CellIdentifier)
        }
        
        cell?.imageView?.image = (self.routesDict[routeAry[indexPath.row]] as Route).image
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 17)
        cell?.textLabel?.text = (self.routesDict[routeAry[indexPath.row]] as Route).name
        
        cell?.detailTextLabel?.font = UIFont(name: "Avenir", size: 17)
        let localizedMin = I18N.localizedString("MINUTE")
        cell?.detailTextLabel?.text = "\(etaAry[indexPath.row]) \(localizedMin)"

        return cell!
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 20))
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        let routeLabel = UILabel(frame: CGRectMake(15.5, 0, UIScreen.mainScreen().bounds.width - 15.5, 30))
        routeLabel.font = UIFont(name: "Avenir", size: 17)
        routeLabel.text = I18N.localizedString("BUS_ROUTES")
        routeLabel.textAlignment = NSTextAlignment.Left
        view.addSubview(routeLabel)
        
        let timeLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 15.5, 30))
        timeLabel.font = UIFont(name: "Avenir", size: 17)
        timeLabel.text = I18N.localizedString("TIME")
        timeLabel.textAlignment = NSTextAlignment.Right
        view.addSubview(timeLabel)
        return view
    }

}

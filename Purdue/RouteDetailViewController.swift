//
//  RouteDetailViewController.swift
//  Purdue
//
//  Created by George Lo on 1/6/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

class RouteDetailViewController: UITableViewController {
    
    var route: Route?
    var stops: [Stop] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = route!.name
        self.tableView.rowHeight = 50
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        let decodedStops = NSUserDefaults.standardUserDefaults().objectForKey("Bus_Stops") as NSData
        let stopsDict = NSKeyedUnarchiver.unarchiveObjectWithData(decodedStops) as NSMutableDictionary
        
        for stopId in route!.stops as [NSNumber] {
            stops.append((stopsDict[stopId] as Stop))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return stops.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        let stop = stops[indexPath.row] as Stop
        cell?.imageView?.image = UIImage(named: "Stop")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell?.imageView?.tintColor = ColorUtils.Cool.DarkBlue
        cell?.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        cell?.textLabel?.numberOfLines = 2
        cell?.textLabel?.text = stop.name
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = StopDetailViewController()
        detailVC.stop = stops[indexPath.row] as Stop
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

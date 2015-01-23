//
//  SafetyViewController.swift
//  Purdue
//
//  Created by George Lo on 1/20/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

class SafetyViewController: UITableViewController {
    
    let safetyKeys = [
        "SAFETY_RESOURCES",
        "SAFETY_PURDUE_ALERT",
        "SAFETY_FIREEVACUATION_PROCEDURES",
        "SAFETY_EVAC_PERSONS_WITH_DISABILITIES",
        "SAFETY_MENTAL_HEALTH_EMERGENCY",
        "SAFETY_SHELTER_IN_PLACE",
        "SAFETY_ACTIVE_SHOOTER",
        "SAFETY_SEVERE_WEATHER_TORNADO_WARNING",
        "SAFETY_HAZARDOUS_MATERIALS",
        "SAFETY_EARTHQUAKE",
        "SAFETY_BOMB_THREAT_SUSPICIOUS_PACKAGE"
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadForLocalization()
    }
    
    func reloadForLocalization() {
        self.navigationItem.title = I18N.localizedString("SAFETY_TITLE")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 50
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
        return safetyKeys.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        cell?.imageView?.image = UIImage(named: "SafetyIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell?.imageView?.tintColor = ColorUtils.Legacy.OldGold
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Book", size: 17)
        cell?.textLabel?.text = I18N.localizedString(safetyKeys[indexPath.row])
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let webBrowser = KINWebBrowserViewController.webBrowser()
        webBrowser.navigationItem.title = I18N.localizedString(safetyKeys[indexPath.row])
        webBrowser.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        webBrowser.showsURLInNavigationBar = false
        webBrowser.showsPageTitleInNavigationBar = false
        self.navigationController?.pushViewController(webBrowser, animated: true)
        
        if indexPath.row == 0 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/resources.html")
        } else if indexPath.row == 1 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/purduealert.html")
        } else if indexPath.row == 2 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/fireevac.html")
        } else if indexPath.row == 3 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/disableevac.html")
        } else if indexPath.row == 4 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/mentalhealth.html")
        } else if indexPath.row == 5 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/shelterinplace.html")
        } else if indexPath.row == 6 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/activeshooter.html")
        } else if indexPath.row == 7 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/severeweather.html")
        } else if indexPath.row == 8 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/hazmat.html")
        } else if indexPath.row == 9 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/earthquake.html")
        } else if indexPath.row == 10 {
            webBrowser.loadURLString("https://www.purdue.edu/ehps/emergency_preparedness/flipchart/bombthreat.html")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

//
//  ScheduleViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController {
    
    var loggedIn = false
    
    let sectionNames = ["SCHEDULE_UNIVERSITY_EVENTS", "SCHEDULE_PERSONAL_SCHEDULE"]
    let rowNames = [
        ["SCHEDULE_ACADEMIC", "SCHEDULE_ADMISSION", "SCHEDULE_ARTS_AND_CULTURE", "SCHEDULE_CAREER_PROGRAMS", "SCHEDULE_COLLEGE_AND_SCHOOLS", "SCHEDULE_CONTINUING_EDUCATION", "SCHEDULE_LIBRARIES", "SCHEDULE_PROSPECTIVE_STUDENTS", "SCHEDULE_REC_SPORTS", "SCHEDULE_REGISTRAR", "SCHEDULE_DIVERSITY_AND_INCLUSIVE"],
        ["SCHEDULE_CLASS_SCHEDULE"]
    ]
    
    let universityEventUrls = [
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=13-0%2c26-50&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=41-0%2c9-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=5-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=6-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=12-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=31-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=28-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=9-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=44-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=26-0&range=next365",
        "https://calendar.purdue.edu/calendar/default.aspx?type=&view=Category&category=40-0&range=next365"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = I18N.localizedString("SCHEDULE_TITLE")
        loggedIn = AccountUtils.getUsername() != nil && AccountUtils.getPassword() != nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return loggedIn == true ? 2 : 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return rowNames[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        cell?.imageView?.image = UIImage(named: "Event")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell?.imageView?.tintColor = ColorUtils.Legacy.OldGold
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 17)
        cell?.textLabel?.text = I18N.localizedString(rowNames[indexPath.section][indexPath.row])
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let webBrowser = WebBrowserViewController()
            webBrowser.navigationItem.title = I18N.localizedString(rowNames[indexPath.section][indexPath.row])
            webBrowser.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            webBrowser.urlString = universityEventUrls[indexPath.row]
            self.navigationController?.pushViewController(webBrowser, animated: true)
        } else if indexPath.section == 1 {
            let detailVC = UserScheduleViewController()
            detailVC.navigationItem.title = I18N.localizedString(rowNames[indexPath.section][indexPath.row])
            detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30))
        view.backgroundColor = ColorUtils.Legacy.OldGold
        
        let textLabel = UILabel(frame: CGRectMake(15.5, 0, UIScreen.mainScreen().bounds.width - 15.5, 30))
        textLabel.font = UIFont(name: "Avenir", size: 17)
        textLabel.text = I18N.localizedString(sectionNames[section])
        textLabel.textAlignment = NSTextAlignment.Left
        textLabel.textColor = UIColor.whiteColor()
        view.addSubview(textLabel)
        
        return view
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

}

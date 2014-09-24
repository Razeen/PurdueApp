//
//  SideMenuViewController.swift
//  Purdue
//
//  Created by George Lo on 9/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
    
    let sectionNames: [String] = [
        NSLocalizedString("ACADEMICS", comment: ""),
        NSLocalizedString("LIFE", comment: ""),
        NSLocalizedString("MAPS", comment: ""),
        NSLocalizedString("MEDIA", comment: ""),
        NSLocalizedString("OTHERS", comment: "")
    ]
    let rowNames: [[String]] = [
        [
            NSLocalizedString("BLACKBOARD", comment: ""),
            NSLocalizedString("MYMAIL", comment: ""),
            NSLocalizedString("SCHEDULE", comment: "")
        ],
        [
            NSLocalizedString("BANDWIDTH", comment: ""),
            NSLocalizedString("BUS", comment: ""),
            NSLocalizedString("COREC", comment: ""),
            NSLocalizedString("GAMES", comment: ""),
            NSLocalizedString("MENU", comment: ""),
            NSLocalizedString("NEWS", comment: ""),
            NSLocalizedString("WEATHER", comment: "")
        ],
        [
            NSLocalizedString("LABS", comment: ""),
            NSLocalizedString("LIBRARY", comment: ""),
            NSLocalizedString("MAP", comment: "")
        ],
        [
            NSLocalizedString("PHOTOS", comment: ""),
            NSLocalizedString("VIDEOS", comment: "")
        ],
        [
            NSLocalizedString("ABOUT", comment: ""),
            NSLocalizedString("DIRECTORY", comment: ""),
            NSLocalizedString("SETTINGS", comment: ""),
            NSLocalizedString("STORE", comment: "")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.Left;
        self.extendedLayoutIncludesOpaqueBars = false;
        self.automaticallyAdjustsScrollViewInsets = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return rowNames.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNames[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell!.textLabel?.text = rowNames[indexPath.section][indexPath.row]

        return cell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

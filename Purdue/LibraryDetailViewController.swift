//
//  LibraryDetailViewController.swift
//  Purdue
//
//  Created by George Lo on 12/21/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class LibraryDetailViewController: UITableViewController {
    
    var titles = [I18N.localizedString("NAME"), I18N.localizedString("LOCATION"), I18N.localizedString("PHONE"), I18N.localizedString("EMAIL"), I18N.localizedString("ADDRESS"), I18N.localizedString("HOURS")]
    var currentLibrary: Library?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = currentLibrary?.name?.stringByReplacingOccurrencesOfString(" Library", withString: "")
        if currentLibrary?.note != nil {
            titles.append(I18N.localizedString("SPECIAL_NOTE"))
        }
        
        let imageView = UIImageView(image: UIImage(named: currentLibrary!.imageName!))
        imageView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width * 0.5)
        self.tableView.tableHeaderView = imageView
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
        return titles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            
            if indexPath.row == 4 {
                cell?.detailTextLabel?.numberOfLines = 0
            } else if indexPath.row == 5 {
                cell?.detailTextLabel?.numberOfLines = 0
            }
        }
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 17)
        cell?.textLabel?.text = titles[indexPath.row]
        
        cell?.detailTextLabel?.font = UIFont(name: "Avenir-Book", size: 14)
        if indexPath.row == 0 {
            cell?.detailTextLabel?.text = currentLibrary?.name
        } else if indexPath.row == 1 {
            cell?.detailTextLabel?.text = currentLibrary?.location
        } else if indexPath.row == 2 {
            cell?.detailTextLabel?.text = currentLibrary?.phone
        } else if indexPath.row == 3 {
            cell?.detailTextLabel?.text = currentLibrary?.email
        } else if indexPath.row == 4 {
            cell?.detailTextLabel?.text = currentLibrary?.address
        } else if indexPath.row == 5 {
            cell?.detailTextLabel?.text = currentLibrary?.hours
        } else if indexPath.row == 6 {
            cell?.detailTextLabel?.text = currentLibrary?.note
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        } else if indexPath.row == 1 {
            return 65
        } else if indexPath.row == 2 {
            return 65
        } else if indexPath.row == 3 {
            return 65
        } else if indexPath.row == 4 {
            return 85
        } else if indexPath.row == 5 {
            return 190
        } else if indexPath.row == 6 {
            return 65
        }
        
        return 65
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

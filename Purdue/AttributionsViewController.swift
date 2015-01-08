//
//  AttributionsViewController.swift
//  Purdue
//
//  Created by George Lo on 1/7/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

class AttributionsViewController: UITableViewController {
    
    let libraryNames: [String] = [
        "AsyncImageView",
        "BButton",
        "CWPopup",
        "ECSlidingViewController",
        "FXBlurView",
        "KeychainWrapper",
        "KINWebBrowser",
        "MailCore2",
        "MRProgress",
        "MWPhotoBrowser",
        "QTree",
        "SCLAlertView",
        "XMLReader"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = I18N.localizedString("ATTRIBUTIONS")
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return libraryNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.imageView?.image = UIImage(named: "Attributions")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell?.imageView?.tintColor = ColorUtils.Cool.DarkBlue
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Book", size: 17)
        cell?.textLabel?.text = libraryNames[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

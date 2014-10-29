//
//  SideMenuViewController.swift
//  Purdue
//
//  Created by George Lo on 9/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import QuartzCore

class SideMenuViewController: UITableViewController {
    
    let imageNames: [String] = [
        "Mail",
        "Blackboard",
        "Schedule",
        "Bus",
        "Map",
        "Labs",
        "Co-Rec",
        "Games",
        "Menu",
        "News",
        "Weather",
        "Library",
        "Photos",
        "Videos",
        "Directory",
        "Bandwidth",
        "Store"
    ]
    
    let rowNames: [String] = [
        "MyMail",
        "Blackboard",
        NSLocalizedString("SCHEDULE", comment: ""),
        NSLocalizedString("BUS", comment: ""),
        NSLocalizedString("MAP", comment: ""),
        NSLocalizedString("LABS", comment: ""),
        NSLocalizedString("COREC", comment: ""),
        NSLocalizedString("GAMES", comment: ""),
        NSLocalizedString("MENU", comment: ""),
        NSLocalizedString("NEWS", comment: ""),
        NSLocalizedString("WEATHER", comment: ""),
        NSLocalizedString("LIBRARY", comment: ""),
        NSLocalizedString("PHOTOS", comment: ""),
        NSLocalizedString("VIDEOS", comment: ""),
        NSLocalizedString("DIRECTORY", comment: ""),
        NSLocalizedString("BANDWIDTH", comment: ""),
        NSLocalizedString("STORE", comment: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = false;
        self.automaticallyAdjustsScrollViewInsets = false;
        self.view.backgroundColor = UIColor(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1)
        self.tableView.rowHeight = 67
        self.tableView.separatorColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        let kImageViewId = 101
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            
            // Separators
            if (indexPath.row < rowNames.count-1) {
                let bottomLayer: CALayer = CALayer()
                bottomLayer.frame = CGRectMake(0, self.tableView.rowHeight-1, 1000, 1)
                bottomLayer.backgroundColor = UIColor(white: 0.35, alpha: 1.0).CGColor
                cell?.layer.addSublayer(bottomLayer)
            }
            
            // Trans
            let itemSize: CGSize = CGSizeMake(30, 1)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale)
            let imageRect: CGRect = CGRectMake(0, 0, itemSize.width, itemSize.height)
            cell?.imageView.image?.drawInRect(imageRect)
            cell?.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let imageView: UIImageView = UIImageView(frame: CGRectMake(21, 21, 25, 25))
            imageView.tag = kImageViewId
            imageView.tintColor = UIColor(white: 0.8, alpha: 0.8)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            cell?.contentView.addSubview(imageView)
        }
        
        let backgroundLayer: CAGradientLayer = CAGradientLayer()
        backgroundLayer.frame = CGRectMake(0, 0, tableView.frame.width, self.tableView.rowHeight)
        backgroundLayer.colors = [UIColor(red: 45.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1).CGColor as AnyObject, UIColor(red: 75.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 1).CGColor as AnyObject]
        backgroundLayer.startPoint = CGPointMake(0, 0.5)
        backgroundLayer.endPoint = CGPointMake(1, 0.5)
        cell?.backgroundView = UIView()
        cell?.backgroundView?.layer.insertSublayer(backgroundLayer, atIndex: 0)
        
        let selectedLayer: CALayer = CALayer()
        selectedLayer.frame = CGRectMake(0, 0, tableView.frame.width, self.tableView.rowHeight)
        selectedLayer.backgroundColor = UIColor(white: 0.35, alpha: 1.0).CGColor
        cell?.selectedBackgroundView = UIView()
        cell?.selectedBackgroundView.layer .insertSublayer(selectedLayer, atIndex: 0)
        
        cell!.textLabel.text = rowNames[indexPath.row]
        cell?.textLabel.textColor = UIColor.whiteColor()
        cell?.textLabel.font = UIFont(name: "Avenir-Roman", size: 18)
        
        (cell?.contentView.viewWithTag(kImageViewId) as UIImageView).image = UIImage(named: imageNames[indexPath.row])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        return cell!
    }
    
}

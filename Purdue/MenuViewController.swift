//
//  MenuViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let diningCourtsButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let restaurantsButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    
    var diningCourtsInfo: [NSDictionary] = []
    var diningCourtsImages: [UIImage] = []
    var restaurantsInfo: [NSDictionary] = []
    
    var selectedIndex = 0
    
    var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    let tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84))
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: false)
        reloadForLocalization()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        /*
        https://api.hfs.purdue.edu/menus/v2/locations/Earhart/2014-10-28
        */
        
        let ScreenWidth = UIScreen.mainScreen().bounds.width
        let ScreenHeight = UIScreen.mainScreen().bounds.height
        let activityIndicatorView = MRActivityIndicatorView(frame: CGRectMake((ScreenWidth - 30) / 2, (ScreenHeight - 30 - 84) / 2, 30, 30))
        activityIndicatorView.tintColor = ColorUtils.Legacy.OldGold
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let diningCourtsData = NSData(contentsOfURL: NSURL(string: "https://api.hfs.purdue.edu/menus/v2/locations")!)
            let diningCourtsDict = NSJSONSerialization.JSONObjectWithData(diningCourtsData!, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            self.diningCourtsInfo = diningCourtsDict["Location"] as [NSDictionary]
            for location in self.diningCourtsInfo {
                let imageId = (location["Images"] as [NSString])[0] as NSString!
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://api.hfs.purdue.edu/menus/v2/file/\(imageId)")!)!)
                self.diningCourtsImages.append(image!)
            }
            
            let restaurantsData = NSData(contentsOfURL: NSURL(string: "https://api.hfs.purdue.edu/menus/v2/retail")!)
            let restaurantsDict = NSJSONSerialization.JSONObjectWithData(restaurantsData!, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            let randomInfo = restaurantsDict["Location"] as NSArray
            self.restaurantsInfo = randomInfo.sortedArrayUsingDescriptors([NSSortDescriptor(key: "Name", ascending: true)]) as [NSDictionary]
            
            dispatch_async(dispatch_get_main_queue(), {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
                
                
                /**
                
                    Setup User Interface
                
                 */
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "MapLocation"), style: UIBarButtonItemStyle.Done, target: self, action: "displayLocations")
                self.navigationItem.rightBarButtonItem?.tintColor = ColorUtils.Core.Brown
                
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width / 2 - 20, UIScreen.mainScreen().bounds.width / 3 - 20)
                flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
                flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
                self.collectionView = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44 - 84), collectionViewLayout: flowLayout)
                self.collectionView.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CellIdentifier")
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.collectionView.backgroundColor = ColorUtils.Core.LightGray
                self.collectionView.contentInset = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5)
                self.view.addSubview(self.collectionView)
                
                self.tableView.rowHeight = 50
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.view.addSubview(self.tableView)
                
                self.view.bringSubviewToFront(self.collectionView)
                
                let separatorLabel = UILabel(frame: CGRectMake(0, 0, 1, 20))
                separatorLabel.backgroundColor = UIColor.lightGrayColor()
                
                self.diningCourtsButton.setTitle(I18N.localizedString("MENU_DINING_COURTS"), forState: UIControlState.Normal)
                self.diningCourtsButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
                self.diningCourtsButton.sizeToFit()
                self.diningCourtsButton.tintColor = UIColor(red: 163.0/255, green: 121.0/255, blue: 44.0/255, alpha: 1)
                self.diningCourtsButton.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
                self.diningCourtsButton.layer.shadowOffset = CGSizeZero
                self.diningCourtsButton.layer.shadowOpacity = 0.5
                self.diningCourtsButton.layer.shadowRadius = 5
                self.diningCourtsButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
                let diningCourtsItem = UIBarButtonItem(customView: self.diningCourtsButton)
                
                self.restaurantsButton.setTitle(I18N.localizedString("MENU_RESTAURANTS"), forState: UIControlState.Normal)
                self.restaurantsButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
                self.restaurantsButton.sizeToFit()
                self.restaurantsButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
                self.restaurantsButton.addTarget(self, action: "changedTab:", forControlEvents: UIControlEvents.TouchUpInside)
                let restaurantsItem = UIBarButtonItem(customView: self.restaurantsButton)
                
                let itemsArray = NSMutableArray(array: [
                    UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
                    diningCourtsItem,
                    UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
                    UIBarButtonItem(customView: separatorLabel),
                    UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
                    restaurantsItem,
                    UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
                    ])
                self.navigationController?.toolbar.translucent = false
                self.navigationController?.setToolbarHidden(false, animated: false)
                self.setToolbarItems(itemsArray, animated: false)
            })
        })
    }
    
    func displayLocations() {
        let detailVC = MenuMapViewController()
        if selectedIndex == 0 {
            detailVC.diningCourts = diningCourtsInfo
        } else if selectedIndex == 1 {
            detailVC.restaurants = restaurantsInfo
        }
        detailVC.option = selectedIndex
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func changedTab(sender: UIButton) {
        diningCourtsButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        diningCourtsButton.layer.shadowRadius = 0
        restaurantsButton.tintColor = UIColor(white: 0.2, alpha: 0.8)
        restaurantsButton.layer.shadowRadius = 0
        
        sender.tintColor = ColorUtils.Legacy.OldGold
        sender.layer.shadowColor = UIColor(red: 227.0/255, green: 174.0/255, blue: 36.0/255, alpha: 1).CGColor
        sender.layer.shadowOffset = CGSizeZero
        sender.layer.shadowOpacity = 0.5
        sender.layer.shadowRadius = 5
        
        if sender == diningCourtsButton {
            selectedIndex = 0
            self.view.bringSubviewToFront(collectionView)
        } else if sender == restaurantsButton {
            selectedIndex = 1
            self.view.bringSubviewToFront(tableView)
        }
    }
    
    func reloadForLocalization() {
        self.navigationItem.title = I18N.localizedString("MENU_TITLE")
        
        self.diningCourtsButton.setTitle(I18N.localizedString("MENU_DINING_COURTS"), forState: UIControlState.Normal)
        self.diningCourtsButton.sizeToFit()
        
        self.restaurantsButton.setTitle(I18N.localizedString("MENU_RESTAURANTS"), forState: UIControlState.Normal)
        self.restaurantsButton.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diningCourtsImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellIdentifier", forIndexPath: indexPath) as UICollectionViewCell
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width / 2 - 20, UIScreen.mainScreen().bounds.width / 3 - 20))
        imageView.image = diningCourtsImages[indexPath.row]
        cell.contentView.addSubview(imageView)
        
        let darkOverlay = UIView(frame: CGRectMake(0, imageView.frame.height - 30, imageView.frame.width, 30))
        darkOverlay.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        cell.contentView.addSubview(darkOverlay)
        
        let textLabel = UILabel(frame: CGRectMake(0, imageView.frame.height - darkOverlay.frame.height, darkOverlay.frame.width, darkOverlay.frame.height))
        textLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        textLabel.text = diningCourtsInfo[indexPath.row]["Name"] as? String
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.textColor = ColorUtils.Cool.LightBlue
        cell.contentView.addSubview(textLabel)
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DiningCourtDetailViewController()
        detailVC.diningCourtInfo = diningCourtsInfo[indexPath.row]
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        self.navigationController?.pushViewController(detailVC, animated: true)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return restaurantsInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        cell?.imageView?.image = UIImage(named: "Utensils")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell?.imageView?.tintColor = ColorUtils.Cool.DarkBlue
        
        cell?.textLabel?.font = UIFont(name: "Avenir-Book", size: 19)
        cell?.textLabel?.text = restaurantsInfo[indexPath.row]["Name"] as? String
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = RestaurantDetailViewController()
        detailVC.restaurantInfo = restaurantsInfo[indexPath.row]
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

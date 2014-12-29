//
//  MapViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var allBuildings: [Building] = []
    var resBuildings: [Building] = []
    
    let searchViewController = UITableViewController()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = I18N.localizedString("MAP_TITLE")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search"), style: UIBarButtonItemStyle.Done, target: self, action: "showSearchVC")
        
        let mapView: MKMapView = MKMapView(frame: CGRectZero)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.427821, -86.917633), 1000, 1000), animated: true)
        mapView.addOverlay(BuildingOverlay())
        mapView.delegate = self
        self.view = mapView
        
        var err: NSError?
        let dict = XMLReader.dictionaryForXMLString(MapUtils.getXMLString(), error: &err)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            for markerDict in (dict["markers"] as NSDictionary)["marker"] as [NSDictionary] {
                let building = Building(fullname: markerDict["name"] as String!, abbreviation: markerDict["abbreviation"] as String!, latitude: (markerDict["lat"] as NSString!).doubleValue, longitude: (markerDict["lng"] as NSString!).doubleValue)
                self.allBuildings.append(building)
                self.resBuildings.append(building)
            }
        })
    }
    
    func showSearchVC() {
        searchViewController.tableView.rowHeight = 60
        searchViewController.tableView.dataSource = self
        searchViewController.tableView.delegate = self
        let searchBar = UISearchBar(frame: CGRectMake(0, 0, searchViewController.tableView.frame.width, 44))
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        searchBar.placeholder = I18N.localizedString("MAP_BUILDING_SEARCH_PROMPT")
        searchViewController.tableView.tableHeaderView = searchBar
        searchViewController.navigationItem.title = I18N.localizedString("MAP_BUILDING_SEARCH")
        searchViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: UIBarButtonItemStyle.Done, target: self, action: "dismissViewController")
        
        self.presentViewController(AppDelegate.createNavController(searchViewController), animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.utf16Count == 0 {
            resBuildings = allBuildings
        } else {
            resBuildings = allBuildings.filter({
                (building: Building) -> Bool in
                return building.fullname!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil || building.abbreviation!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
            })
            searchViewController.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay.isKindOfClass(BuildingOverlay.classForCoder()) {
            return BuildingOverlayView(overlay: overlay, overlayImage: UIImage(named: "Buildings")!)
        }
        return nil
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resBuildings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
        }
        
        let building = resBuildings[indexPath.row]
        cell?.textLabel?.text = building.fullname
        cell?.detailTextLabel?.text = building.abbreviation
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchViewController.dismissViewControllerAnimated(true, completion: {
            let mapView = self.view as MKMapView
            let building = self.resBuildings[indexPath.row]
            let coordinate = CLLocationCoordinate2DMake(building.latitude, building.longitude)
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.title = building.fullname
            annotation.subtitle = building.abbreviation
            annotation.coordinate = coordinate
            mapView.setCenterCoordinate(coordinate, animated: true)
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        })
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

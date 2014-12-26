//
//  MapViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate {

    var allBuildings: [Building] = []
    var resBuildings: [Building] = []
    
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
        
        return cell!
    }
}

//
//  MapViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("MAP_TITLE", comment: "")
        
        var mapView: GMSMapView = GMSMapView.mapWithFrame(CGRectZero, camera:GMSCameraPosition.cameraWithLatitude(40.427821,
            longitude:-86.917633, zoom:15))
        mapView.mapType = kGMSTypeNormal
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.indoorPicker = true
        self.view = mapView
        
        let southWest = CLLocationCoordinate2DMake(40.412660, -86.934770)
        let northEast = CLLocationCoordinate2DMake(40.437060, -86.908370)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        
        let buildings = UIImage(named: "Buildings")
        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: buildings)
        overlay.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  LabsViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class LabsViewController: UIViewController, GMSMapViewDelegate {
    
    // <LabBuildingName>: <LabBuilding> for faster mapping
    var buildings = NSMutableDictionary()
    let calloutView = SMCalloutView()
    let emptyCalloutView = UIView(frame: CGRectZero)
    var mapView: GMSMapView = GMSMapView.mapWithFrame(CGRectZero, camera:GMSCameraPosition.cameraWithLatitude(40.427821,
        longitude:-86.917633, zoom:15))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "ITaP Labs";
        
        let button = UIButton.buttonWithType(.DetailDisclosure) as UIButton
        button.addTarget(self, action: "calloutAccessoryButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        calloutView.rightAccessoryView = button

        mapView.mapType = kGMSTypeNormal
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.indoorPicker = true
        mapView.delegate = self
        
        mapView.frame = self.view.frame
        self.view.addSubview(mapView)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var err: NSError?
            let htmlString = NSString(contentsOfURL: NSURL(string: "https://lslab.ics.purdue.edu/icsWeb/LabMap")!, encoding: NSUTF8StringEncoding, error: &err)
            if htmlString != nil {
                for i in 1...23 {
                    let patternStringArray = [
                        "maparray\\[\(i)\\]\\[0\\] = \"(.*?)\";",
                        "maparray\\[\(i)\\]\\[1\\] = (.*?);",
                        "maparray\\[\(i)\\]\\[2\\] = (.*?);",
                        "maparray\\[\(i)\\]\\[3\\] = (.*?);",
                        "maparray\\[\(i)\\]\\[4\\] = \"(.*?)\";",
                    ]
                    
                    var building = LabBuilding()
                    for j in 0...4 {
                        let regex = NSRegularExpression(pattern: patternStringArray[j], options: NSRegularExpressionOptions.DotMatchesLineSeparators, error: &err)
                        let matches = regex?.matchesInString(htmlString!, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, htmlString!.length)) as [NSTextCheckingResult]
                        for match in matches {
                            let matchRange = match.rangeAtIndex(1)
                            var matchString: NSString = htmlString!.substringWithRange(matchRange)
                            if j == 0 {
                                building.name = matchString
                            } else if j == 1 {
                                building.latitude = matchString.doubleValue
                            } else if j == 2 {
                                building.longitude = matchString.doubleValue
                            } else if j == 3 {
                                building.availability = matchString.integerValue
                            } else {
                                matchString = matchString.substringToIndex(matchString.length - 4)
                                matchString = matchString.stringByReplacingOccurrencesOfString("<br><br>", withString: "\n\n").stringByReplacingOccurrencesOfString("<br>", withString: "\n")
                                matchString = matchString.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: NSMakeRange(0, matchString.length))
                                let roomMatches = matchString.componentsSeparatedByString("\n\n") as [NSString]
                                for roomMatch in roomMatches {
                                    let infoMatch = roomMatch.componentsSeparatedByString("\n") as [NSString]
                                    var room = LabRoom()
                                    for k in 0...infoMatch.count-1 {
                                        let info: NSString = infoMatch[k]
                                        if k == 0 {
                                            room.name = info
                                        } else if k == 1 {
                                            if info.rangeOfString("CLOSED", options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound {
                                                room.status = "Closed"
                                            } else if info.rangeOfString("Class in Session", options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound {
                                                room.status = "Class in Session"
                                            } else {
                                                room.status = "Open"
                                                if info.rangeOfString("Windows", options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound {
                                                    room.windows = info.stringByReplacingOccurrencesOfString("Windows 7 Enterprise SP1 stations a", withString: "A")
                                                } else if info.rangeOfString("Mac", options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound {
                                                    room.mac = info.stringByReplacingOccurrencesOfString("Mac OS X 10.6.8  stations a", withString: "A")
                                                } else {
                                                    room.unknown = info.stringByReplacingOccurrencesOfString("unknown stations a", withString: "A")
                                                }
                                            }
                                        } else {
                                            if info.rangeOfString("Windows", options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound {
                                                room.windows = info.stringByReplacingOccurrencesOfString("Windows 7 Enterprise SP1 stations a", withString: "A")
                                            } else if info.rangeOfString("Mac", options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound {
                                                room.mac = info.stringByReplacingOccurrencesOfString("Mac OS X 10.6.8  stations a", withString: "A")
                                            } else {
                                                room.unknown = info.stringByReplacingOccurrencesOfString("unknown stations a", withString: "A")
                                            }
                                        }
                                    }
                                    building.addLabRoom(room)
                                }
                            }
                        }
                    }
                    self.buildings[building.name!] = building
                    dispatch_async(dispatch_get_main_queue(), {
                        var marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake(building.latitude!, building.longitude!)
                        marker.title = building.name!
                        marker.snippet = "\(building.availability) Computers available"
                        marker.appearAnimation = kGMSMarkerAnimationPop
                        if building.availability > 0 && building.availability <= 15 {
                            marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 0.953, green: 0.612, blue: 0.071, alpha: 1))
                        } else if building.availability > 15 {
                            marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 0.153, green: 0.682, blue: 0.376, alpha: 1))
                        }
                        marker.map = self.mapView
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    println("Error")
                    SCLAlertView().showError(self, title: "Error Loading", subTitle: "Please try reloading later")
                })
            }
        })
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func calloutAccessoryButtonTapped() {
        if self.mapView.selectedMarker != nil {
            let marker = self.mapView.selectedMarker
            let building = buildings[marker.title] as LabBuilding
            let rooms = building.rooms
            let detailVC = LabDetailsViewController()
            detailVC.rooms = rooms
            detailVC.navigationItem.title = building.name
            detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
            detailVC.navigationItem.leftBarButtonItem?.tintColor = UIColor(white: 0.3, alpha: 1.0)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let anchor =  marker.position;
        let point = mapView.projection.pointForCoordinate(anchor)
        
        self.calloutView.title = marker.title
        self.calloutView.subtitle = marker.snippet
        self.calloutView.calloutOffset = CGPointMake(0, -40)
        
        self.calloutView.hidden = false
        
        let calloutRect = CGRectMake(point.x, point.y, 0, 0)
        self.calloutView.presentCalloutFromRect(calloutRect, inView: mapView, constrainedToView: mapView, animated: true)
        
        return self.emptyCalloutView
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        if (mapView.selectedMarker != nil && self.calloutView.hidden == false) {
            let anchor = mapView.selectedMarker.position
            let arrowPt = self.calloutView.backgroundView.arrowPoint
            var pt = mapView.projection.pointForCoordinate(anchor)
            pt = CGPointMake(pt.x - arrowPt.x, pt.y - arrowPt.y - 40)
            
            self.calloutView.frame = CGRectMake(pt.x, pt.y, self.calloutView.frame.width, self.calloutView.frame.height)
        } else {
            self.calloutView.hidden = true
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.calloutView.hidden = true
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        mapView.selectedMarker = marker
        return true
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

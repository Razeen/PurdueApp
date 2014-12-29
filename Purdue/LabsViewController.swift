//
//  LabsViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class LabsViewController: UIViewController, MKMapViewDelegate {
    
    // <LabBuildingName>: <LabBuilding> for faster mapping
    var buildings = NSMutableDictionary()
    var mapView: MKMapView = MKMapView(frame: CGRectZero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = I18N.localizedString("LAB_TITLE");

        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(40.427821, -86.917633), MKCoordinateSpanMake(0.0380936352247474, 0.0294399289282126)), animated: true)
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
                        let annotation = MKPointAnnotation()
                        annotation.title = building.name!
                        let COMPUTERS_AVAIL = I18N.localizedString("LAB_COMPUTERS_AVAILABLE")
                        annotation.subtitle = "\(building.availability) \(COMPUTERS_AVAIL)"
                        annotation.coordinate = CLLocationCoordinate2DMake(building.latitude!, building.longitude!)
                        self.mapView.addAnnotation(annotation)
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let title = I18N.localizedString("ERROR")
                    let subtitle = I18N.localizedString("TRY_LATER")
                    SCLAlertView().showError(self, title: title, subTitle: subtitle)
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
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var pinAnnotation: MKPinAnnotationView?
        if annotation.isKindOfClass(MKPointAnnotation.classForCoder()) {
            let PinIdentifier = "PinIdentifier"
            pinAnnotation = mapView.dequeueReusableAnnotationViewWithIdentifier(PinIdentifier) as? MKPinAnnotationView
            if pinAnnotation == nil {
                pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: PinIdentifier)
            }
            pinAnnotation?.canShowCallout = true
            pinAnnotation?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            
            let availability = annotation.subtitle?.componentsSeparatedByString(" ").first!.toInt()
            if availability == 0 {
                pinAnnotation?.pinColor = MKPinAnnotationColor.Red
            } else if availability > 0 && availability <= 15 {
                pinAnnotation?.pinColor = MKPinAnnotationColor.Purple
            } else if availability > 15 {
                pinAnnotation?.pinColor = MKPinAnnotationColor.Green
            }
        }
        return pinAnnotation
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let annotation = view.annotation
        let building = buildings[annotation.title!] as LabBuilding
        let rooms = building.rooms
        let detailVC = LabDetailsViewController()
        detailVC.rooms = rooms
        detailVC.navigationItem.title = building.name
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

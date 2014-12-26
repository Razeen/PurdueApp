//
//  LibraryViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class LibraryViewController: UIViewController, MKMapViewDelegate {
    
    // from the Drupal JSON object at https://www.lib.purdue.edu/about/directions
    let libraries: [Library] = [
        Library(name: "Siegesmund Engineering Library", location: "Potter Engr. Center, Room 160", imageName: "LIB_ENGR", latitude: 40.427655, longitude: -86.913051, phone: "(765) 494-2869", email: "enginlib@purdue.edu", address: "500 Central Dr.\nWest Lafayette, IN 47907-2022", hours: "MON\t08:00 AM - 12:00 AM\nTUE\t\t08:00 AM - 12:00 AM\nWED\t08:00 AM - 12:00 AM\nTHU\t\t08:00 AM - 12:00 AM\nFRI\t\t08:00 AM - 06:00 PM\nSAT\t\t11:00 AM - 05:00 PM\nSUN\t11:00 AM - 12:00 PM"),
        Library(name: "Aviation Technology Library", location: "Airport Terminal Room 163", imageName: "LIB_AVTECH", latitude: 40.416195, longitude: -86.930963, phone: "(765) 494-7640", email: "avtlib@purdue.edu", address: "1501 Aviation Drive\nWest Lafayette, IN 47907", hours: "MON\t08:00 AM - 07:00 PM\nTUE\t\t08:00 AM - 07:00 PM\nWED\t08:00 AM - 07:00 PM\nTHU\t\t08:00 AM - 07:00 PM\nFRI\t\t08:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 05:00 PM\nSUN\t01:00 PM - 05:00 PM"),
        Library(name: "M. G. Mellon Library of Chemistry", location: "Wetherill Laboratory of Chemistry 301", imageName: "LIB_CHEM", latitude: 40.426396, longitude: -86.913056, phone: "(765) 494-2862", email: "chemlib@purdue.edu", address: "560 Oval Drive\nWest Lafayette, IN 47907-2058", hours: "MON\t08:00 AM - 10:00 PM\nTUE\t\t08:00 AM - 10:00 PM\nWED\t08:00 AM - 10:00 PM\nTHU\t\t08:00 AM - 10:00 PM\nFRI\t\t08:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 05:00 PM\nSUN\t01:00 PM - 10:00 PM"),
        Library(name: "EAPS Library", location: "HAMP 2215B", imageName: "LIB_EAPS", latitude: 40.430255, longitude: -86.914821, phone: "(765) 494-3264", email: "easlib@purdue.edu", address: "550 Stadium Avenue\nWest Lafayette, IN 47907", hours: "MON\t08:00 AM - 10:00 PM\nTUE\t\t08:00 AM - 10:00 PM\nWED\t08:00 AM - 10:00 PM\nTHU\t\t08:00 AM - 10:00 PM\nFRI\t\t08:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 05:00 PM\nSUN\t01:00 PM - 10:00 PM"),
        Library(name: "HSSE Library", location: "Stewart Center Room 135", imageName: "LIB_HSSE", latitude: 40.424951, longitude: -86.913298, phone: "(765) 494-2831", email: "hsselib@purdue.edu", address: "504 West State Street\nWest Lafayette, IN 47907", hours: "MON\t07:00 AM - 12:00 AM\nTUE\t\t07:00 AM - 12:00 AM\nWED\t07:00 AM - 12:00 AM\nTHU\t\t07:00 AM - 12:00 AM\nFRI\t\t11:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 06:00 PM\nSUN\t01:00 PM - 12:00 AM"),
        Library(name: "Life Sciences Library", location: "Lilly Hall of Life Sciences Rm. 2400", imageName: "LIB_LILY", latitude: 40.423602, longitude: -86.918246, phone: "(765) 494-2910", email: "lifelib@purdue.edu", address: "915 West State Street\nWest Lafayette, IN 47907-2058", hours: "MON\t08:00 AM - 10:00 PM\nTUE\t\t08:00 AM - 10:00 PM\nWED\t08:00 AM - 10:00 PM\nTHU\t\t08:00 AM - 10:00 PM\nFRI\t\t08:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 05:00 PM\nSUN\t01:00 PM - 10:00 PM"),
        Library(name: "Mathematical Sciences Library", location: "Mathematical Sciences Building 311", imageName: "LIB_MATH", latitude: 40.42616, longitude: -86.915744, phone: "(765) 494-2855", email: "mathlib@purdue.edu", address: "105 North University Street\nWest Lafayette, IN 47907-2058", hours: "MON\t08:00 AM - 10:00 PM\nTUE\t\t08:00 AM - 10:00 PM\nWED\t08:00 AM - 10:00 PM\nTHU\t\t08:00 AM - 10:00 PM\nFRI\t\t08:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 05:00 PM\nSUN\t01:00 PM - 10:00 PM"),
        Library(name: "Parrish Library of Management & Economics", location: "Krannert Building - 2nd Floor", imageName: "LIB_MGMT", latitude: 40.423718, longitude: -86.91075, phone: "(765) 494-2920", email: "parrlib@purdue.edu", address: "403 West State Street\nWest Lafayette, IN 47907-2058", hours: "MON\tOpens 24 Hours     \nTUE\t\tOpens 24 Hours     \nWED\tOpens 24 Hours     \nTHU\t\tOpens 24 Hours     \nFRI\t\t08:00 AM - 08:00 PM\nSAT\t\t10:30 AM - 04:30 PM\nSUN\t11:00 AM - 12:00 AM", note: "Building locks at midnight"),
        Library(name: "PNHS Library", location: "Heine Pharmacy Building Room 272", imageName: "LIB_PNHS", latitude: 40.429796, longitude: -86.915908, phone: "(765) 494-1416", email: "pharlib@purdue.edu", address: "575 Stadium Mall\nWest Lafayette, IN 47907", hours: "MON\t08:00 AM - 10:00 PM\nTUE\t\t08:00 AM - 10:00 PM\nWED\t08:00 AM - 10:00 PM\nTHU\t\t08:00 AM - 10:00 PM\nFRI\t\t08:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 05:00 PM\nSUN\t01:00 PM - 10:00 PM"),
        Library(name: "Physics Library", location: "Physics Building 290", imageName: "LIB_PHYS", latitude: 40.429876, longitude: -86.912895, phone: "(765) 494-2858", email: "physlib@purdue.edu", address: "525 Northwestern Avenue\nWest Lafayette, IN 47907-2058", hours: "MON\t08:00 AM - 10:00 PM\nTUE\t\t08:00 AM - 10:00 PM\nWED\t08:00 AM - 10:00 PM\nTHU\t\t08:00 AM - 10:00 PM\nFRI\t\t08:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 05:00 PM\nSUN\t01:00 PM - 10:00 PM"),
        Library(name: "Veterinary Medical Library", location: "Lynn Hall of Veterinary Medicine 1133", imageName: "LIB_VETM", latitude: 40.419483, longitude: -86.914773, phone: "(765) 494-2853", email: "vetmlib@purdue.edu", address: "625 Harrison Street\nWest Lafayette, IN 47907-2058", hours: "MON\t08:00 AM - 10:00 PM\nTUE\t\t08:00 AM - 10:00 PM\nWED\t08:00 AM - 10:00 PM\nTHU\t\t08:00 AM - 10:00 PM\nFRI\t\t08:00 AM - 05:00 PM\nSAT\t\t01:00 PM - 05:00 PM\nSUN\t01:00 PM - 10:00 PM"),
        Library(name: "Hicks Undergraduate Library", location: "Hicks Undergraduate Library Ground Floor", imageName: "LIB_HICKS", latitude: 40.42451, longitude: -86.912654, phone: "(765) 494-6733", email: "ugrl@purdue.edu", address: "504 West State Street\nWest Lafayette, IN 47907-2058", hours: "MON\t07:00 AM - 12:00 AM\nTUE\t\t07:00 AM - 12:00 AM\nWED\t07:00 AM - 12:00 AM\nTHU\t\t07:00 AM - 12:00 AM\nFRI\t\t07:00 AM - 06:00 PM\nSAT\t\t01:00 PM - 06:00 PM\nSUN\t01:00 PM - 12:00 AM", note: "Open 24 Hours with PUID card swipe"),
        Library(name: "Black Cultural Center Library", location: "Black Cultural Center - Library", imageName: "LIB_BCC", latitude: 40.427524, longitude: -86.919483, phone: "(765) 496-6660", email: "bcclib@purdue.edu", address: "1100 Third Street\nWest Lafayette, IN 47907-2109", hours:
            "MON\t08:00 AM - 09:30 PM\nTUE\t\t08:00 AM - 09:30 PM\nWED\t08:00 AM - 09:30 PM\nTHU\t\t08:00 AM - 09:30 PM\nFRI\t\t08:00 AM - 06:00 PM\nSAT\t\tCLOSED             \nSUN\t06:00 PM - 09:00 PM"),
        Library(name: "Archives and Special Collections", location: "Stewart Center, 4th floor of HSSE library", imageName: "LIB_SPCOL", latitude: 40.424946, longitude: -86.912855, phone: "(765) 494-2839", email: "spcoll@purdue.edu", address: "504 W. State Street\nWest Lafayette, IN 47907", hours: "MON\t10:00 AM - 04:30 PM\nTUE\t\t10:00 AM - 04:30 PM\nWED\t10:00 AM - 04:30 PM\nTHU\t\t10:00 AM - 04:30 PM\nFRI\t\t10:00 AM - 04:30 PM\nSAT\t\tCLOSED             \nSUN\tCLOSED             ")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("LIBRARY_TITLE", comment: "")

        let mapView = MKMapView(frame: CGRectZero)
        let viewRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(40.4260224640727, -86.9213018749628), MKCoordinateSpanMake(0.0380936352247474, 0.0294399289282126))
        mapView.setRegion(viewRegion, animated: true)
        mapView.delegate = self
        self.view = mapView
        
        for library in libraries {
            let annotation = MKPointAnnotation()
            annotation.title = library.name
            annotation.subtitle = library.location
            annotation.coordinate = CLLocationCoordinate2DMake(library.latitude, library.longitude)
            mapView.addAnnotation(annotation)
        }
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
        }
        return pinAnnotation
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        for library in libraries {
            if library.name == view.annotation.title {
                let viewController = LibraryDetailViewController()
                viewController.currentLibrary = library
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

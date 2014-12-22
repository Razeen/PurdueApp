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
        Library(name: "Siegesmund Engineering Library", location: "Potter Engr. Center, Room 160", latitude: 40.427655, longitude: -86.913051),
        Library(name: "Aviation Technology Library", location: "Airport Terminal Room 163", latitude: 40.416195, longitude: -86.930963),
        Library(name: "M. G. Mellon Library of Chemistry", location: "Wetherill Laboratory of Chemistry 301", latitude: 40.426396, longitude: -86.913056),
        Library(name: "EAPS Library", location: "HAMP 2215B", latitude: 40.430255, longitude: -86.914821),
        Library(name: "HSSE Library", location: "Stewart Center Room 135", latitude: 40.424951, longitude: -86.913298),
        Library(name: "Life Sciences Library", location: "Lilly Hall of Life Sciences Rm. 2400", latitude: 40.423602, longitude: -86.918246),
        Library(name: "Mathematical Sciences Library", location: "Mathematical Sciences Building 311", latitude: 40.42616, longitude: -86.915744),
        Library(name: "Parrish Library of Management & Economics", location: "Krannert Building - 2nd Floor", latitude: 40.423718, longitude: -86.91075),
        Library(name: "PNHS Library", location: "Heine Pharmacy Building Room 272", latitude: 40.429796, longitude: -86.915908),
        Library(name: "Physics Library", location: "Physics Building 290", latitude: 40.429876, longitude: -86.912895),
        Library(name: "Veterinary Medical Library", location: "Lynn Hall of Veterinary Medicine 1133", latitude: 40.419483, longitude: -86.914773),
        Library(name: "Hicks Undergraduate Library", location: "Hicks Undergraduate Library Ground Floor", latitude: 40.42451, longitude: -86.912654),
        Library(name: "Black Cultural Center Library", location: "Black Cultural Center - Library", latitude: 40.427524, longitude: -86.919483),
        Library(name: "Archives and Special Collections", location: "Stewart Center, 4th floor of HSSE library", latitude: 40.424946, longitude: -86.912855)
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
            let identifier = "Pin"
            pinAnnotation = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            if pinAnnotation == nil {
                pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            pinAnnotation?.canShowCallout = true
            
            pinAnnotation?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        }
        return pinAnnotation
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        view.annotation.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

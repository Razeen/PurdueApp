//
//  MenuMapViewController.swift
//  Purdue
//
//  Created by George Lo on 1/7/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class MenuMapViewController: UIViewController, MKMapViewDelegate {
    
    var diningCourts: [NSDictionary]?
    var restaurants: [NSDictionary]?
    
    /**
        Options
        - 0: Dining Courts
        - 1: Restaurants
     */
    var option = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MKMapView(frame: self.view.frame)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.427821, -86.917633), 3000, 3000), animated: false)
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        if option == 0 {
            self.navigationItem.title = I18N.localizedString("MENU_DINING_COURTS")
            for diningCourt in diningCourts! {
                let annotation = MKPointAnnotation()
                annotation.title = diningCourt["Name"] as String
                annotation.coordinate = CLLocationCoordinate2DMake(diningCourt["Latitude"] as Double, diningCourt["Longitude"] as Double)
                mapView.addAnnotation(annotation)
            }
        } else if option == 1 {
            self.navigationItem.title = I18N.localizedString("MENU_RESTAURANTS")
            for restaurant in restaurants! {
                let annotation = MKPointAnnotation()
                annotation.title = restaurant["Name"] as String
                annotation.coordinate = CLLocationCoordinate2DMake(restaurant["Latitude"] as Double, restaurant["Longitude"] as Double)
                mapView.addAnnotation(annotation)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKPointAnnotation.classForCoder()) {
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("Annotation") as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
                pinView?.canShowCallout = true
                pinView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            } else {
                pinView?.annotation = annotation
            }
            return pinView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let title = view.annotation.title
        if option == 0 {
            for diningCourt in diningCourts! {
                if diningCourt["Name"] as? String == title {
                    break
                }
            }
        } else if option == 1 {
            for restaurant in restaurants! {
                if restaurant["Name"] as? String == title {
                    let detailVC = RestaurantDetailViewController()
                    detailVC.restaurantInfo = restaurant
                    detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
                    self.navigationController?.pushViewController(detailVC, animated: true)
                    break
                }
            }
        }
    }

}

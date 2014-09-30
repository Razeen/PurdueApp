//
//  ViewController.swift
//  Purdue
//
//  Created by George Lo on 9/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("WEATHER", comment: "")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(white: 0.3, alpha: 1.0)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: CGFloat(24)),
            NSForegroundColorAttributeName: UIColor(white: 0.2, alpha: 1.0)
        ]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        var error: NSError?
        let weatherData: NSData = NSData(contentsOfURL: NSURL.URLWithString("http://api.openweathermap.org/data/2.5/weather?lat=40.424113&lon=-86.921410"), options: NSDataReadingOptions.DataReadingUncached, error: &error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


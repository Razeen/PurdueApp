//
//  ViewController.swift
//  Purdue
//
//  Created by George Lo on 9/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label : UILabel = UILabel(frame: CGRectMake(0, 0, 100, 100))
        label.text = "Hello"
        view.addSubview(label)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


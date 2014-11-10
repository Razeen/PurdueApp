//
//  LabDetailsViewController.swift
//  Purdue
//
//  Created by George Lo on 11/9/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class LabDetailsViewController: UIViewController {
    
    var rooms: [LabRoom]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor(white: 0.93, alpha: 1.0)
        self.view.addSubview(scrollView)
        
        var currentHeight: CGFloat = 10
        
        for room in rooms! {
            var cardHeight: CGFloat = 35
            let cardView = UIView()
            let nameLabel = UILabel(frame: CGRectMake(15, 10, scrollView.frame.width - 30, 25))
            nameLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
            nameLabel.text = room.name
            nameLabel.contentMode = UIViewContentMode.Center
            nameLabel.textAlignment = NSTextAlignment.Left
            cardView.backgroundColor = UIColor.whiteColor()
            cardView.addSubview(nameLabel)
            
            if room.status == "Closed" {
                let statusLabel = UILabel(frame: CGRectMake(15, cardHeight, scrollView.frame.width - 10, 25))
                statusLabel.font = UIFont(name: "Avenir", size: 15)
                statusLabel.text = room.status
                statusLabel.textColor = UIColor.redColor()
                statusLabel.contentMode = UIViewContentMode.Center
                statusLabel.textAlignment = NSTextAlignment.Left
                cardView.addSubview(statusLabel)
                cardHeight += 25
            } else if room.status == "Class in Session" {
                let statusLabel = UILabel(frame: CGRectMake(15, cardHeight, scrollView.frame.width - 10, 25))
                statusLabel.font = UIFont(name: "Avenir", size: 15)
                statusLabel.text = room.status
                statusLabel.textColor = UIColor.orangeColor()
                statusLabel.contentMode = UIViewContentMode.Center
                statusLabel.textAlignment = NSTextAlignment.Left
                cardView.addSubview(statusLabel)
                cardHeight += 25
            } else { // Open
                if room.windows != nil {
                    let windowsIV = UIImageView(frame: CGRectMake(15, cardHeight + 1.5, 20, 20))
                    windowsIV.image = UIImage(named: "Microsoft")
                    windowsIV.contentMode = UIViewContentMode.ScaleAspectFit
                    cardView.addSubview(windowsIV)
                    let windowsLabel = UILabel(frame: CGRectMake(42.5, cardHeight, scrollView.frame.width - 5 - 42.5, 25))
                    windowsLabel.font = UIFont(name: "Avenir", size: 15)
                    windowsLabel.text = "Windows: " + room.windows!
                    windowsLabel.contentMode = UIViewContentMode.Center
                    windowsLabel.textAlignment = NSTextAlignment.Left
                    cardView.addSubview(windowsLabel)
                    cardHeight += 25
                }
                if room.mac != nil {
                    let macIV = UIImageView(frame: CGRectMake(15, cardHeight + 1.5, 20, 20))
                    macIV.image = UIImage(named: "Apple")
                    macIV.contentMode = UIViewContentMode.ScaleAspectFit
                    cardView.addSubview(macIV)
                    let macLabel = UILabel(frame: CGRectMake(42.5, cardHeight, scrollView.frame.width - 5 - 42.5, 25))
                    macLabel.font = UIFont(name: "Avenir", size: 15)
                    macLabel.text = "Mac: " + room.mac!
                    macLabel.contentMode = UIViewContentMode.TopLeft
                    macLabel.textAlignment = NSTextAlignment.Left
                    cardView.addSubview(macLabel)
                    cardHeight += 25
                }
                if room.unknown != nil {
                    let unknownIV = UIImageView(frame: CGRectMake(15, cardHeight + 1.5, 20, 20))
                    unknownIV.image = UIImage(named: "Unknown")
                    unknownIV.contentMode = UIViewContentMode.ScaleAspectFit
                    cardView.addSubview(unknownIV)
                    let unknownLabel = UILabel(frame: CGRectMake(42.5, cardHeight, scrollView.frame.width - 5 - 42.5, 25))
                    unknownLabel.font = UIFont(name: "Avenir", size: 15)
                    unknownLabel.text = "Unknown: " + room.unknown!
                    unknownLabel.contentMode = UIViewContentMode.Center
                    unknownLabel.textAlignment = NSTextAlignment.Left
                    cardView.addSubview(unknownLabel)
                    cardHeight += 25
                }
            }
            cardHeight += 10
            
            cardView.frame = CGRectMake(10, currentHeight, UIScreen.mainScreen().bounds.width - 20, cardHeight)
            cardView.layer.shadowColor = UIColor.blackColor().CGColor
            cardView.layer.shadowOffset = CGSizeMake(1.5, 1.5)
            cardView.layer.shadowOpacity = 0.3
            cardView.layer.shadowRadius = 1
            cardView.layer.borderColor = UIColor.lightGrayColor().CGColor
            cardView.layer.borderWidth = 1
            scrollView.addSubview(cardView)
            currentHeight += cardHeight + 15
        }
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, currentHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  PUNavigationBar.swift
//  Purdue
//
//  Created by George Lo on 9/25/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class PUNavigationBar: UINavigationBar {
    
    let barIncrease: CGFloat = 20.0
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var amendedSize: CGSize = super.sizeThatFits(size)
        amendedSize.height += barIncrease
        return amendedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitleVerticalPositionAdjustment(-barIncrease*0.3, forBarMetrics: UIBarMetrics.Default)
        self.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: CGFloat(24))!,
            NSForegroundColorAttributeName: UIColor(white: 0.2, alpha: 1.0)]
        let classNamesToReposition: NSArray = ["UINavigationItemView", "UINavigationButton"]
        
        var i: Int
        for i = 0; i < self.subviews.count; i++ {
            let view: UIView = self.subviews[i] as UIView
            if classNamesToReposition.containsObject(NSStringFromClass(view.classForCoder)) {
                let frame: CGRect = CGRectMake(view.frame.origin.x, view.frame.origin.y - barIncrease * 0.4, view.frame.width, view.frame.height)
                view.frame = frame
            }
        }
    }
    
}

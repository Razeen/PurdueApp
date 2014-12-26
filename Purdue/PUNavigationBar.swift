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
        self.barTintColor = UIColor.whiteColor()
        self.translucent = true
        self.setTitleVerticalPositionAdjustment(-barIncrease * 0.3  , forBarMetrics: UIBarMetrics.Default)
        self.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Bold", size: CGFloat(22))!,
            NSForegroundColorAttributeName: UIColor(white: 0.2, alpha: 1.0)]
        
        let classNamesToReposition: NSArray = ["UINavigationItemView", "UINavigationButton"]
        for view in self.subviews as [UIView] {
            if classNamesToReposition.containsObject(NSStringFromClass(view.classForCoder)) {
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - barIncrease * 0.4, view.frame.width, view.frame.height)
            }
        }
    }
    
}

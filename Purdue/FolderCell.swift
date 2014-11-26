//
//  FolderCell.swift
//  Purdue
//
//  Created by George Lo on 11/26/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class FolderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = CGRectMake(self.layoutMargins.left, (self.frame.height - 28) / 2 - 1, 28, 28)
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.textLabel.frame = CGRectMake(self.layoutMargins.left + 43, 0, self.frame.width - self.layoutMargins.left - 43 - 30, self.frame.height)
    }
    
}

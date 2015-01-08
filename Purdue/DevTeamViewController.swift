//
//  DevTeamViewController.swift
//  Purdue
//
//  Created by George Lo on 1/7/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"
let imageViewTag = 101
let textLabelTag = 102
let headerTag = 103

class DevTeamViewController: UICollectionViewController {
    
    let names: [[String]] = [
        ["George Lo"],
        ["Eric Lees", "Grey Chen", "Jaehyun Ahn", "Kartik Sawant", "Ming Lee", "Rhys Howell", "Tarang Khanna", "Tim Vincent", "William Huang"],
        ["Daniel Trinkle", "Martin Sickafoose", "Tim Korb"]
    ]
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(100, 125)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 20, 10)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.headerReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 30)
        super.init(collectionViewLayout: flowLayout)
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        self.collectionView!.contentInset = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = I18N.localizedString("DEVELOPMENT_TEAM")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return names.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names[section].count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        if cell.contentView.viewWithTag(imageViewTag) == nil {
            let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
            imageView.tag = imageViewTag
            imageView.layer.cornerRadius = 50
            imageView.layer.borderColor = ColorUtils.Cool.DarkBlue.CGColor
            imageView.layer.borderWidth = 2.5
            imageView.layer.masksToBounds = true
            cell.contentView.addSubview(imageView)
        }
        (cell.contentView.viewWithTag(imageViewTag) as UIImageView).image = UIImage(named: names[indexPath.section][indexPath.row].stringByReplacingOccurrencesOfString(" ", withString: ""))
        
        if cell.contentView.viewWithTag(textLabelTag) == nil {
            let textLabel = UILabel(frame: CGRectMake(0, 105, 100, 20))
            textLabel.tag = textLabelTag
            textLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
            textLabel.textAlignment = NSTextAlignment.Center
            cell.contentView.addSubview(textLabel)
        }
        (cell.contentView.viewWithTag(textLabelTag) as UILabel).text = names[indexPath.section][indexPath.row]
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as? UICollectionReusableView
        if reusableView == nil {
            reusableView = UICollectionReusableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30))
        }
        
        if reusableView?.viewWithTag(headerTag) == nil {
            let label = UILabel(frame: CGRectMake(-2.5, -2.5, UIScreen.mainScreen().bounds.width, 30))
            label.backgroundColor = ColorUtils.Legacy.OldGold
            label.font = UIFont(name: "Avenir", size: 17)
            label.tag = headerTag
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()
            reusableView?.addSubview(label)
        }
        if indexPath.section == 0 {
            (reusableView?.viewWithTag(headerTag) as UILabel).text = I18N.localizedString("LEAD_DEVELOPER")
        } else if indexPath.section == 1 {
            (reusableView?.viewWithTag(headerTag) as UILabel).text = I18N.localizedString("DEVELOPERS")
        } else if indexPath.section == 2 {
            (reusableView?.viewWithTag(headerTag) as UILabel).text = I18N.localizedString("SPECIAL_THANKS")
        }
        return reusableView!
    }

}

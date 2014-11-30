//
//  MessagesCell.swift
//  Purdue
//
//  Created by George Lo on 11/27/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    var messageRenderingOperation: MCOIMAPMessageRenderingOperation?
    
    let readView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 30 - 35 - 10, 14, 10, 10))
    let fromLabel = UILabel(frame: CGRectMake(20, 10, UIScreen.mainScreen().bounds.width - 30 - 35 - 15 - 20, 20))
    let subjectLabel = UILabel(frame: CGRectMake(20, 32.5, UIScreen.mainScreen().bounds.width - 30 - 30, 15))
    let descLabel = UILabel(frame: CGRectMake(20, 50, UIScreen.mainScreen().bounds.width - 30 - 30, 35))
    let timeLabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 30 - 35, 10, 40, 20))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        
        readView.layer.cornerRadius = 5
        readView.layer.masksToBounds = true
        self.contentView.addSubview(readView)
        
        fromLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
        self.contentView.addSubview(fromLabel)
        
        subjectLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        self.contentView.addSubview(subjectLabel)
        
        descLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        descLabel.numberOfLines = 2
        self.contentView.addSubview(descLabel)
        
        timeLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        timeLabel.textAlignment = NSTextAlignment.Right
        timeLabel.textColor = UIColor.grayColor()
        self.contentView.addSubview(timeLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDate(date: NSDate) {
        var dateString: String?
        let mailDate = NSCalendar.currentCalendar().components(NSCalendarUnit.EraCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: date)
        let todayDate = NSCalendar.currentCalendar().components(NSCalendarUnit.EraCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: NSDate())
        if todayDate.era == mailDate.era && todayDate.year == mailDate.year && todayDate.month == mailDate.month && todayDate.day == mailDate.day {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            dateString = dateFormatter.stringFromDate(date)
        } else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            dateString = dateFormatter.stringFromDate(date)
        }
        timeLabel.text = dateString!
    }
    
    override func prepareForReuse() {
        messageRenderingOperation = nil
        descLabel.text = ""
    }
    
}

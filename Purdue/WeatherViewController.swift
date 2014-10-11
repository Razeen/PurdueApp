//
//  ViewController.swift
//  Purdue
//
//  Created by George Lo on 9/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let locationImage: UIImageView = UIImageView(image: UIImage(named: "Location").imageWithRenderingMode(.AlwaysTemplate))
    let locationLabel: UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2-130/2+7.5, 85.0, 130, 20))
    let weatherImage: UIImageView = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/4, 105, UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.width/2))
    let temperatureLabel: UILabel = UILabel(frame: CGRectMake(0, 105+UIScreen.mainScreen().bounds.width/2-5, UIScreen.mainScreen().bounds.width, 85))
    let cardSV: UIScrollView = UIScrollView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height*0.75, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height*0.25))
    let humidityView: UIView = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height*0.75-60, UIScreen.mainScreen().bounds.width/4+2.5, 40))
    let windView: UIView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/4*3-2.5, UIScreen.mainScreen().bounds.height*0.75-60, UIScreen.mainScreen().bounds.width/4+2.5, 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("WEATHER", comment: "")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(white: 0.3, alpha: 1.0)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: CGFloat(24)),
            NSForegroundColorAttributeName: UIColor(white: 0.2, alpha: 1.0)
        ]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setupUI()
        loadWeather()
    }
    
    func setupUI() {
        locationImage.tintColor = UIColor(red: 0, green: 122.0/255, blue: 1, alpha: 1)
        locationImage.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2-130/2-15, 87.5, 15, 15)
        locationImage.contentMode = .ScaleAspectFit
        
        locationLabel.font = UIFont(name: "Helvetica-Bold", size: 15)
        locationLabel.textAlignment = .Center
        locationLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
        locationLabel.text = "West Lafayette, IN"
        
        weatherImage.contentMode = .ScaleAspectFit
        
        temperatureLabel.textAlignment = .Center
        
        let humidIcon: UIImageView = UIImageView(frame: CGRectMake(10, 2.5, 15, 15))
        humidIcon.image = UIImage(named: "Humidity").imageWithRenderingMode(.AlwaysTemplate)
        humidIcon.contentMode = UIViewContentMode.ScaleAspectFit
        humidIcon.tintColor = UIColor(white: 0.5, alpha: 1.0)
        let humidTitleLabel: UILabel = UILabel(frame: CGRectMake(32.5, 0, humidityView.frame.width-32.5, 20))
        humidTitleLabel.text = "Humidity"
        humidTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        humidTitleLabel.textColor = UIColor(white: 0.3, alpha: 1.0)
        humidityView.addSubview(humidIcon)
        humidityView.addSubview(humidTitleLabel)
        
        let windIcon: UIImageView = UIImageView(frame: CGRectMake(10, 2.5, 15, 15))
        windIcon.image = UIImage(named: "Wind").imageWithRenderingMode(.AlwaysTemplate)
        windIcon.contentMode = UIViewContentMode.ScaleAspectFit
        windIcon.tintColor = UIColor(white: 0.5, alpha: 1.0)
        let windTitleLabel: UILabel = UILabel(frame: CGRectMake(32.5, 0, windView.frame.width-32.5, 20))
        windTitleLabel.text = "Wind"
        windTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        windTitleLabel.textColor = UIColor(white: 0.3, alpha: 1.0)
        windView.addSubview(windIcon)
        windView.addSubview(windTitleLabel)
        
        cardSV.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        cardSV.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.height*0.15*7.00, cardSV.frame.height)
        
        let dayColors: [UIColor] = [
            UIColor(red: 0.204, green: 0.596, blue: 0.859, alpha: 1),
            UIColor(red: 0.161, green: 0.502, blue: 0.725, alpha: 1),
            UIColor(red: 0.102, green: 0.737, blue: 0.612, alpha: 1),
            UIColor(red: 0.086, green: 0.627, blue: 0.522, alpha: 1),
            UIColor(red: 0.204, green: 0.286, blue: 0.369, alpha: 1),
            UIColor(red: 0.173, green: 0.243, blue: 0.314, alpha: 1),
            UIColor(red: 0.953, green: 0.612, blue: 0.071, alpha: 1)
        ]
        let dayNames: [String] = ["Sun", "Mon", "Tues", "Wed", "Thu", "Fri", "Sat"]
        var error: NSError?
        let weatherData: NSData = NSData(contentsOfURL: NSURL.URLWithString("http://api.openweathermap.org/data/2.5/forecast/daily?lat=40.424113&lon=-86.921410&units=imperial&cnt=7"), options: NSDataReadingOptions.DataReadingUncached, error: &error)
        if weatherData != NSNull() {
            let weatherDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(weatherData, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
            let weatherDates: [NSDictionary] = weatherDict["list"] as [NSDictionary]
            var i = 0;
            for weatherDetails: NSDictionary in weatherDates {
                let weatherCode: Int = (weatherDetails["weather"] as NSArray)[0]["id"] as Int
                let iconURL: NSURL = WeatherHelper.getIconURL(weatherCode, dimension: 128)
                let cardView: UIView = makeCard(i, color: dayColors[i], title: dayNames[(i+NSCalendar(calendarIdentifier: NSGregorianCalendar).components(.WeekdayCalendarUnit, fromDate: NSDate.date()).weekday-1)%7], iconUrl: iconURL, temperature: Int((weatherDetails["temp"] as NSDictionary)["day"] as Float))
                cardSV.addSubview(cardView)
                i++
            }
        }
        
        self.view.addSubview(locationImage)
        self.view.addSubview(locationLabel)
        self.view.addSubview(weatherImage)
        self.view.addSubview(temperatureLabel)
        self.view.addSubview(humidityView)
        self.view.addSubview(windView)
        self.view.addSubview(cardSV)
    }
    
    func makeCard(count: Int, color: UIColor, title: String, iconUrl: NSURL, temperature: Int) -> UIView {
        var width: CGFloat = CGFloat(UIScreen.mainScreen().bounds.height*0.15)
        let cardView: UIView = UIView(frame: CGRectMake(width*CGFloat(count), 0, width, UIScreen.mainScreen().bounds.height*0.25))
        cardView.backgroundColor = color
        
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.height*0.15, cardView.frame.height*0.30))
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        
        var error: NSError?
        
        let weatherIcon: UIImageView = UIImageView(frame: CGRectMake(0, cardView.frame.height*0.30, UIScreen.mainScreen().bounds.height*0.15, cardView.frame.height*0.45))
        weatherIcon.contentMode = UIViewContentMode.ScaleAspectFit
        weatherIcon.image = UIImage(data: NSData.dataWithContentsOfURL(iconUrl, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &error))
        
        let temperatureLabel: UILabel = UILabel(frame: CGRectMake(0, cardView.frame.height*0.75, UIScreen.mainScreen().bounds.height*0.15, cardView.frame.height*0.20))
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "\(temperature)o", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 20), NSForegroundColorAttributeName: UIColor.whiteColor()])
        attrString.addAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 9), NSBaselineOffsetAttributeName: 14], range: NSMakeRange(attrString.length-1, 1))
        let parStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        parStyle.alignment = NSTextAlignment.Center
        attrString.addAttribute(NSParagraphStyleAttributeName, value: parStyle, range: NSMakeRange(0, attrString.length))
        temperatureLabel.attributedText = attrString;
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(weatherIcon)
        cardView.addSubview(temperatureLabel)
        return cardView
    }
    
    func loadWeather() {
        var error: NSError?
        let weatherData: NSData = NSData(contentsOfURL: NSURL.URLWithString("http://api.openweathermap.org/data/2.5/weather?lat=40.424113&lon=-86.921410&units=imperial"), options: NSDataReadingOptions.DataReadingUncached, error: &error)
        if weatherData != NSNull() {
            let weatherDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(weatherData, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
            let weatherCode: Int = (weatherDict["weather"] as NSArray)[0]["id"] as Int
            let iconURL: NSURL = WeatherHelper.getIconURL(weatherCode, dimension: 256)
            weatherImage.image = UIImage(data: NSData.dataWithContentsOfURL(iconURL, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &error))
            setTemperature(Int((weatherDict["main"] as NSDictionary)["temp"] as Float))
            
            let humidity: Int = (weatherDict["main"] as NSDictionary)["humidity"] as Int
            let humidDetailLabel: UILabel = UILabel(frame: CGRectMake(32.5, 20, humidityView.frame.width-32.5, 20))
            humidDetailLabel.text = "\(humidity)%"
            humidDetailLabel.font = UIFont(name: "Avenir", size: 15)
            humidDetailLabel.textColor = UIColor(white: 0.3, alpha: 1.0)
            humidityView.addSubview(humidDetailLabel)
            
            let windSpeed: Int = Int(round((weatherDict["wind"] as NSDictionary)["speed"] as Float))
            let windDetailLabel: UILabel = UILabel(frame: CGRectMake(32.5, 20, windView.frame.width-32.5, 20))
            windDetailLabel.text = "\(windSpeed) mph"
            windDetailLabel.font = UIFont(name: "Avenir", size: 15)
            windDetailLabel.textColor = UIColor(white: 0.3, alpha: 1.0)
            windView.addSubview(windDetailLabel)
            
            println(weatherDict);
        }
    }
    
    func setTemperature(temperature: Int) {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "\(temperature)o", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 100)])
        attrString.addAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 20), NSBaselineOffsetAttributeName: 64], range: NSMakeRange(attrString.length-1, 1))
        let parStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        parStyle.alignment = NSTextAlignment.Center
        attrString.addAttribute(NSParagraphStyleAttributeName, value: parStyle, range: NSMakeRange(0, attrString.length))
        temperatureLabel.attributedText = attrString;
        temperatureLabel.textColor = UIColor(white: 0.3, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


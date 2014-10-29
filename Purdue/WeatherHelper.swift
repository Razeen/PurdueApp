//
//  WeatherHelper.swift
//  Purdue
//
//  Created by George Lo on 10/9/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import Foundation

class WeatherHelper: NSObject {
    
    class func getIconURL(weatherCode: Int, dimension: Int) -> NSURL {
        // Defaults to a question mark icon (Flat design)
        var urlString: String = "http://echo5webdesign.com/wp-content/uploads/2014/01/Questionmark-icon.png"
        
        // Parse Weathercode
        if weatherCode / 100 == 2 { // Thunderstorm
            urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/rain_s_cloudy.png"
        } else if weatherCode / 100 == 3 { // Drizzle
            urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/rain.png"
        } else if weatherCode / 100 == 5 { // Rain
            urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/rain.png"
        } else if weatherCode / 100 == 6 { // Snow
            urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/snow.png"
        } else if weatherCode / 100 == 7 { // Atmosphere
            urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/fog.png"
        } else if weatherCode / 100 == 8 { // Clouds
            urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/cloudy.png"
        } else if weatherCode / 100 == 9 { // Others
            if weatherCode == 900 { // Tornado
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/thunderstorms.png"
            } else if weatherCode == 901 { // Tropical Storm
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/thunderstorms.png"
            } else if weatherCode == 902 { // Hurricane
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/thunderstorms.png"
            } else if weatherCode == 903 { // Cold
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/cloudy.png"
            } else if weatherCode == 904 { // Hot
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/hot.png"
            } else if weatherCode == 905 { // Windy
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 906 { // Hail
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/light_snow.png"
            } else if weatherCode == 951 { // Calm
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/sunny.png"
            } else if weatherCode == 952 { // Light breeze
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 953 { // Gentle breeze
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 954 { // Moderate breeze
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 955 { // Fresb breeze
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 956 { // Strong breeze
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 957 { // High wind
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 958 { // Gale
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 959 { // Severe gale
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/windy.png"
            } else if weatherCode == 960 { // Storm
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/thunderstorms.png"
            } else if weatherCode == 961 { // Violent storm
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/thunderstorms.png"
            } else if weatherCode == 962 { // Hurricane
                urlString = "https://ssl.gstatic.com/onebox/weather/\(dimension)/thunderstorms.png"
            }
        }
        
        let iconUrl: NSURL = NSURL(string: urlString)!
        return iconUrl
    }

}
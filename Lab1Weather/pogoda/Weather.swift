//
//  Weather.swift
//  pogoda
//
//  Created by Bartłomiej Zachariasz on 16/10/2019.
//  Copyright © 2019 Bartłomiej Zachariasz. All rights reserved.
//


import Foundation
import CoreLocation

struct Weather {
    let weatherType:String
    let maxTemp:Double
    let minTemp:Double
    let windSpeed:Double
    let windDirection:Double
    let rainfall:Double
    let pressure:Double
    let icon:String
    let timeStamp:Double
    
    init(json:[String:Any]) {
        self.weatherType = json["summary"] as! String
        
        self.maxTemp = json["temperatureMax"] as! Double
        
        self.minTemp = json["temperatureMin"] as! Double
        
        self.windSpeed = json["windSpeed"] as! Double
        
        self.windDirection = json["windBearing"] as! Double
        
        self.rainfall = json["humidity"] as! Double
        
        self.pressure = json["pressure"] as! Double
        
        self.icon = json["icon"] as! String
        
        self.timeStamp = json["time"] as! Double
    }

    
    static func getData (latitude: String, longitude: String, completion: @escaping ([Weather]?) -> ()) {
        
        let API_PATH = "https://api.darksky.net/forecast/23a47f99989a11f4a6a3494dd8c5cbfa/"
        
        let url = API_PATH + "\(latitude),\(longitude)?exclude=currently,minutely,hourly&units=si"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        task.resume()
    }
    

}

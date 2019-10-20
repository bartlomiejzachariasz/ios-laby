//
//  ViewController.swift
//  pogoda
//
//  Created by Bartłomiej Zachariasz on 16/10/2019.
//  Copyright © 2019 Bartłomiej Zachariasz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherType: UITextField!
    
    @IBOutlet weak var maxTemp: UITextField!
    
    @IBOutlet weak var minTemp: UITextField!
    
    @IBOutlet weak var windSpeed: UITextField!
    
    @IBOutlet weak var rainfall: UITextField!
    
    @IBOutlet weak var pressure: UITextField!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var time: UITextField!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nexButton: UIButton!
    
    @IBOutlet weak var windBearing: UITextField!
    
    
    var data = [Weather]()
    
    var i: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Weather.getData(latitude: "19.9449799", longitude: "50.0646501", completion:{ (results:[Weather]?) in
            
            if let weatherData = results {
                self.data = weatherData
                
                DispatchQueue.main.async {
                    self.reloadData(i: self.i)
                }
                
            }
        })
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if(self.i < self.data.count - 1) {
            self.i += 1
            self.reloadData(i: self.i)
        }
    }
    
    
    @IBAction func prevButton(_ sender: Any) {
        if(self.i > 0) {
            self.i -= 1
            self.reloadData(i: self.i)
        }
    }
    
    
    func reloadData(i: Int) {
        self.displayDate(unixtimeInterval: self.data[i].timeStamp)
        self.weatherType.text = self.data[i].weatherType
        self.maxTemp.text = String(self.data[i].maxTemp)
        self.rainfall.text = String(self.data[i].rainfall)
        self.pressure.text = String(self.data[i].pressure)
        self.minTemp.text = String(self.data[i].minTemp)
        self.windSpeed.text = String(self.data[i].windSpeed)
        self.icon.image = UIImage(named: self.data[i].icon)
        self.windBearing.text = String(self.data[i].windDirection)
    }
    
    func displayDate(unixtimeInterval: Double) {
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: date)
        self.time.text = strDate
    }


}

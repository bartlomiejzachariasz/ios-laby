//
//  DetailViewController.swift
//  Lab3Weather
//
//  Created by Bartłomiej Zachariasz on 30/10/2019.
//  Copyright © 2019 zachariasz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var data = [Weather]()
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var City: UILabel!
    
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var maxTemp: UITextField!
    
    @IBOutlet weak var minTemo: UITextField!
    
    @IBOutlet weak var windSpeed: UITextField!
    
    @IBOutlet weak var windBearing: UITextField!
    
    @IBOutlet weak var rainfall: UITextField!
    
    @IBOutlet weak var pressure: UITextField!
    
    @IBOutlet weak var date: UITextField!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var weatherType: UITextField!
    
    var dayIndex: Int = 0
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.previousButton.isEnabled = false
        // Do any additional setup after loading the view.
        configureView()
        reloadView(dayIndex: dayIndex)
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func reloadView(dayIndex: Int) {
        self.weatherType.text = self.data[dayIndex].weatherType
        self.maxTemp.text = "\(String(self.data[dayIndex].maxTemp)) °C"
        self.minTemo.text = "\(String(self.data[dayIndex].minTemp)) °C"
        self.windSpeed.text = "\(String(self.data[dayIndex].windSpeed)) m/s"
        self.rainfall.text = String(self.data[dayIndex].rainfall)
        self.pressure.text = "\(String(self.data[dayIndex].pressure)) hPa"
        self.icon.image = UIImage(named: self.data[dayIndex].icon)
        self.windBearing.text = self.mapDegreeToDirection(degrees: self.data[dayIndex].windDirection)
        
        self.City.text = self.data[dayIndex].city
        
        self.displayDate(unixtimeInterval: self.data[dayIndex].timeStamp)
    }
    
    func displayDate(unixtimeInterval: Double) {
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: date)
        self.date.text = strDate
    }
    
    @IBAction func previousClicked(_ sender: Any) {
        if(self.dayIndex > 0) {
            self.dayIndex -= 1
            self.reloadView(dayIndex: self.dayIndex)
            self.nextButton.isEnabled = true
        } else {
            self.previousButton.isEnabled = false
        }
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        if(self.dayIndex < self.data.count - 1) {
            self.dayIndex += 1
            self.reloadView(dayIndex: self.dayIndex)
            self.previousButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
    
    func mapDegreeToDirection(degrees: Double) -> String {
        if(degrees >= 337.5 && degrees < 22.5) {
            return "from N to S"
        } else if(degrees >= 22.5 && degrees < 67.5) {
            return "from NE to SW"
        } else if(degrees >= 67.5 && degrees < 112.5) {
            return "from E to W"
        } else if(degrees >= 112.5 && degrees < 157.5) {
            return "from SW to NE"
        } else if(degrees >= 157.5 && degrees < 202.5) {
            return "from S to N"
        } else if(degrees >= 202.5 && degrees < 247.5) {
            return "from SW to NE"
        } else if(degrees >= 247.5 && degrees < 292.5) {
            return "from W to E"
        } else {
            return "from NW to SE"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapVC = segue.destination as! MapViewController

        mapVC.city = self.data[0].city
    }
    
}


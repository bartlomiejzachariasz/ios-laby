//
//  MapViewController.swift
//  Lab3Weather
//
//  Created by Bartłomiej Zachariasz on 11/11/2019.
//  Copyright © 2019 zachariasz. All rights reserved.
//

import Foundation

//
//  DetailViewController.swift
//  Lab3Weather
//
//  Created by Bartłomiej Zachariasz on 30/10/2019.
//  Copyright © 2019 zachariasz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var currentLocation: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    var city: String = ""
    
    let regionRadius: CLLocationDistance = 100000
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.currentLocation.text = city
        getLocationWeather(cityName: city)
    }
    
    func getLocationWeather(cityName: String) {
        let annotation = MKPointAnnotation()
        CLGeocoder().geocodeAddressString(cityName) {
            (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                        annotation.coordinate = location.coordinate
                        self.map.addAnnotation(annotation)
                    self.centerMapOnLocation(location: location)
                }
            }
        }


        }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: self.regionRadius, longitudinalMeters: self.regionRadius)
        self.map.setRegion(coordinateRegion, animated: true)
       
    }
    }
    



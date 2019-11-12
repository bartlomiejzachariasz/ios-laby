//
//  MasterViewController.swift
//  Lab2Weather
//
//  Created by Bartłomiej Zachariasz on 30/10/2019.
//  Copyright © 2019 zachariasz. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var citySearchBar: UISearchBar!
    
    var detailViewController: DetailViewController? = nil
    
    var weatherArray = [[Weather]]()
    
    var valueToPass:[Weather]!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocationWeather(cityName: "Warsaw")
        getLocationWeather(cityName: "Melbourne")
        getLocationWeather(cityName: "Novosibirsk")
        
        citySearchBar.delegate = self

        navigationItem.leftBarButtonItem = editButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let location = searchBar.text, !location.isEmpty {
            getLocationWeather(cityName: location)
        }
    }
    
    func getLocationWeather(cityName: String) {
        CLGeocoder().geocodeAddressString(cityName) {
            (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.getData(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.latitude), city: cityName, completion: {
                        (results:[Weather]?) in
                        if let weatherRecord = results {
                            self.weatherArray.append(weatherRecord)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController

        let tableVC = navVC.viewControllers.first as! DetailViewController

        let index = tableView.indexPathForSelectedRow?.row
        
        tableVC.data = weatherArray[index!]

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let weatherCell = weatherArray[indexPath.row]
        
        cell.textLabel!.text = weatherCell[0].city
        cell.detailTextLabel!.text = "\(Int(weatherCell[0].currentTemp)) °C"
        cell.imageView?.image = UIImage(named: weatherCell[0].icon)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
}


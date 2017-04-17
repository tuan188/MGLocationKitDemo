//
//  LocationViewController.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {

    let locationService = LocationService()
    
    @IBOutlet weak var tableView: UITableView!
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadData()
    }
    
    fileprivate func loadData() {
        locationService.all(currentDate).then { [weak self] locationList -> Void in
            self?.locations = locationList.sorted { $0.createdTime > $1.createdTime }
            self?.tableView.reloadData()
        }.catch { (error) in
            print(error)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        loadData()
    }
    @IBAction func deleteAll(_ sender: Any) {
        locationService.deleteAll().then { [weak self] _ -> Void in
            DispatchQueue.main.async {
                self?.loadData()
            }
        }.catch { (error) in
            log.error(error)
        }
        
    }

}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        
        if let locationCell = cell as? LocationCell {
            locationCell.location = locations[indexPath.row]
        }
        
        return cell
    }
}

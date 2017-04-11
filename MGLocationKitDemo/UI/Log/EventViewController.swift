//
//  EventViewController.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/3/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var events = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    fileprivate func loadData() {
        event.all(currentDate).then { [weak self] eventList -> Void in
            self?.events = eventList
            self?.tableView.reloadData()
            }.catch { (error) in
                print(error)
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        event.deleteAll().then { [weak self] _ -> Void in
            DispatchQueue.main.async {
                self?.loadData()
            }
            }.catch { (error) in
                log.error(error)
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        loadData()
    }
    

}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        if let eventCell = cell as? EventCell {
            eventCell.event = events[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

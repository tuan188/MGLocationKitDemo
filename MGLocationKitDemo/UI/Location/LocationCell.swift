//
//  LocationCell.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet var arrivalLabel: UILabel!
    @IBOutlet var departureLabel: UILabel!
    
    var location: Location! {
        didSet {
            timeLabel.text = location.createdTime.fullDateString()
            latLabel.text = String(location.lat)
            lngLabel.text = String(location.lng)
            
            arrivalLabel.text = location.arrivalTime?.fullDateString() ?? ""
            departureLabel.text = location.departureTime?.fullDateString() ?? ""
            
            self.backgroundColor = location.isCard ? UIColor.yellow : UIColor.white
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

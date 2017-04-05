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
    @IBOutlet var accuracyLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet var arrivalLabel: UILabel!
    @IBOutlet var departureLabel: UILabel!
    
    var location: Location! {
        didSet {
            timeLabel.text = location.createdTime.fullDateString
            latLabel.text = String(location.lat)
            lngLabel.text = String(location.lng)
            
            arrivalLabel.text = location.arrivalTime?.fullDateString ?? ""
            departureLabel.text = location.departureTime?.fullDateString ?? ""
            accuracyLabel.text = String(location.accuracy)
            speedLabel.text = String(location.speed)
            
            let color: UIColor
            switch location.type {
            case .arrival:
                color = .green
            case .departure:
                color = .blue
            default:
                color = .white
            }
            
            self.backgroundColor = color
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

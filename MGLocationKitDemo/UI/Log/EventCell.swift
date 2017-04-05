//
//  EventCell.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/3/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var eventLabel: UILabel!
    
    var event: Event! {
        didSet {
            timeLabel.text = event.createdTime.fullDateString
            eventLabel.text = event.content
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

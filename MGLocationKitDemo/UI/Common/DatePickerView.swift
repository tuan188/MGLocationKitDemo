//
//  DatePickerView.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/3/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var cancelAction: (() -> Void)?
    var okAction: ((_ date: Date) -> Void)?
    
    var date: Date! {
        didSet {
            datePicker.date = date
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.datePickerMode = UIDatePickerMode.date
    }
    
    deinit {
        print("DatePickerView deinit")
    }
    
    // MARK: - Events
    
    @IBAction func ok(sender: AnyObject) {
        date = datePicker.date
        okAction?(date)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        cancelAction?()
    }

}

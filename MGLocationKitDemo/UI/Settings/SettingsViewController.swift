//
//  SettingsViewController.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/10/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerDidSave()
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet var distanceThresholdSlider: UISlider!
    @IBOutlet var durationThresholdSlider: UISlider!
    @IBOutlet var horizontalAccuracySlider: UISlider!
    @IBOutlet var annotationSwitch: UISwitch!
    
    @IBOutlet var distanceThresholdLabel: UILabel!
    @IBOutlet var durationThresholdLabel: UILabel!
    @IBOutlet var horizontalAccuracyLabel: UILabel!
    
    weak var delegate: SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceThresholdSlider.value = Float(AppSettings.distanceThreshold)
        durationThresholdSlider.value = Float(AppSettings.durationThreshold)
        horizontalAccuracySlider.value = Float(AppSettings.horizontalAccuracy)
        annotationSwitch.isOn = AppSettings.showAnnotations

        distanceThresholdLabel.text = String(Int(distanceThresholdSlider.value))
        durationThresholdLabel.text = String(Int(durationThresholdSlider.value))
        horizontalAccuracyLabel.text = String(Int(horizontalAccuracySlider.value))
    }

    @IBAction func distanceThresholdSliderValueChanged(_ sender: Any) {
        distanceThresholdLabel.text = String(Int(distanceThresholdSlider.value))
    }

    @IBAction func durationThresholdSliderValueChanged(_ sender: Any) {
        durationThresholdLabel.text = String(Int(durationThresholdSlider.value))
    }
    
    @IBAction func horizontalAccuracySliderValueChanged(_ sender: Any) {
        horizontalAccuracyLabel.text = String(Int(horizontalAccuracySlider.value))
    }
    
    @IBAction func annotationSwitchValueChanged(_ sender: Any) {
        
    }

    @IBAction func save(_ sender: Any) {
        AppSettings.distanceThreshold = Double(Int(distanceThresholdSlider.value))
        AppSettings.durationThreshold = Double(Int(durationThresholdSlider.value))
        AppSettings.horizontalAccuracy = Double(Int(horizontalAccuracySlider.value))
        AppSettings.showAnnotations = annotationSwitch.isOn
        
        self.dismiss(animated: true, completion: nil)
        self.delegate?.settingsViewControllerDidSave()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restore(_ sender: Any) {
        distanceThresholdSlider.value = 60
        durationThresholdSlider.value = 5
        horizontalAccuracySlider.value = 100
        
        distanceThresholdLabel.text = String(Int(distanceThresholdSlider.value))
        durationThresholdLabel.text = String(Int(durationThresholdSlider.value))
        horizontalAccuracyLabel.text = String(Int(horizontalAccuracySlider.value))
        
        annotationSwitch.isOn = false
    }
    
}

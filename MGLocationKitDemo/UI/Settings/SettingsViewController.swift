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
    
    @IBOutlet var distanceThresholdStepper: UIStepper!
    @IBOutlet var durationThresholdStepper: UIStepper!
    @IBOutlet var horizontalAccuracyStepper: UIStepper!
    @IBOutlet var annotationSwitch: UISwitch!
    
    @IBOutlet var distanceThresholdLabel: UILabel!
    @IBOutlet var durationThresholdLabel: UILabel!
    @IBOutlet var horizontalAccuracyLabel: UILabel!
    
    weak var delegate: SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceThresholdStepper.value = AppSettings.distanceThreshold
        durationThresholdStepper.value = AppSettings.durationThreshold
        horizontalAccuracyStepper.value = AppSettings.horizontalAccuracy
        annotationSwitch.isOn = AppSettings.showAnnotations

        distanceThresholdLabel.text = String(Int(distanceThresholdStepper.value))
        durationThresholdLabel.text = String(Int(durationThresholdStepper.value))
        horizontalAccuracyLabel.text = String(Int(horizontalAccuracyStepper.value))
    }

    @IBAction func distanceThresholdStepperValueChanged(_ sender: Any) {
        distanceThresholdLabel.text = String(Int(distanceThresholdStepper.value))
    }

    @IBAction func durationThresholdStepperValueChanged(_ sender: Any) {
        durationThresholdLabel.text = String(Int(durationThresholdStepper.value))
    }
    
    @IBAction func horizontalAccuracyStepperValueChanged(_ sender: Any) {
        horizontalAccuracyLabel.text = String(Int(horizontalAccuracyStepper.value))
    }
    
    @IBAction func annotationSwitchValueChanged(_ sender: Any) {
        
    }

    @IBAction func save(_ sender: Any) {
        AppSettings.distanceThreshold = Double(Int(distanceThresholdStepper.value))
        AppSettings.durationThreshold = Double(Int(durationThresholdStepper.value))
        AppSettings.horizontalAccuracy = Double(Int(horizontalAccuracyStepper.value))
        AppSettings.showAnnotations = annotationSwitch.isOn
        
        self.dismiss(animated: true, completion: nil)
        self.delegate?.settingsViewControllerDidSave()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restore(_ sender: Any) {
        distanceThresholdStepper.value = kDefaultDistanceThreshold
        durationThresholdStepper.value = kDefaultDurationThreadhold
        horizontalAccuracyStepper.value = kDefaultHorizontalAccuracy
        
        distanceThresholdLabel.text = String(Int(distanceThresholdStepper.value))
        durationThresholdLabel.text = String(Int(durationThresholdStepper.value))
        horizontalAccuracyLabel.text = String(Int(horizontalAccuracyStepper.value))
        
        annotationSwitch.isOn = kDefaultShowAnnotations
    }
    
}

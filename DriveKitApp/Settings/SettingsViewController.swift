//
//  SettingsViewController.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 22/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCore
import DriveKitTripAnalysis

class SettingsViewController: UITableViewController {

    @IBOutlet var userIdCell: UITableViewCell!
    @IBOutlet var timeOutValue: UILabel!
    @IBOutlet var loggingSwitch: UISwitch!
    @IBOutlet var sandBoxSwitch: UISwitch!
    @IBOutlet var autoStartSwitch: UISwitch!
    @IBOutlet var timeOutSlider: UISlider!
    @IBOutlet var beaconSwitch: UISwitch!
    @IBOutlet var beaconConfigurationSwitch: UISwitch!
    @IBOutlet var positionSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup() {
        timeOutValue.text = String(SettingsBundleKeys.getTimeoutPref())
        loggingSwitch.isOn = SettingsBundleKeys.getLoggingPref()
        sandBoxSwitch.isOn = SettingsBundleKeys.getSandboxPref()
        autoStartSwitch.isOn = SettingsBundleKeys.getAutoStartPref()
        timeOutSlider.value = Float(SettingsBundleKeys.getTimeoutPref())
        beaconSwitch.isOn = SettingsBundleKeys.getBeaconPref()
        beaconConfigurationSwitch.isOn = SettingsBundleKeys.getBeaconConfigPref()
        positionSwitch.isOn = SettingsBundleKeys.getPositionPref()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            
            let alert = UIAlertController(title: "Update User id", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.keyboardType = UIKeyboardType.default
                textField.text = SettingsBundleKeys.getUserId() ?? ""
            })
            
            let save = UIAlertAction(title: "Save", style: .default, handler: { _ in
                if let textField = alert.textFields?.first, let text = textField.text {
                    self.setUserId(userId: text)
                }
            })
            
            let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            
            alert.addAction(save)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    }
    
    func setUserId(userId: String) {
        SettingsBundleKeys.setUserId(userId: userId)
        DriveKit.shared.registerUser(userId: userId)
        
        self.tableView.reloadData()
    }

    
    @IBAction func didChangeLogginValue(_ sender: Any) {
        SettingsBundleKeys.setLoggingPref(logging: loggingSwitch.isOn)
        if loggingSwitch.isOn {
            DriveKit.shared.enableLogging()
        } else {
            DriveKit.shared.disableLogging()
        }
    }
    
    @IBAction func didChangeSandBoxValue(_ sender: Any) {
        SettingsBundleKeys.setSandboxPref(sandbox: sandBoxSwitch.isOn)
        DriveKit.shared.enableSandboxMode(enable: sandBoxSwitch.isOn)
    }
    
    @IBAction func didChangeAutoStartValue(_ sender: Any) {
        SettingsBundleKeys.setAutoStartPref(autoStart: autoStartSwitch.isOn)
        DriveKitTripAnalysis.shared.activateAutoStart(enable: autoStartSwitch.isOn)
    }
    
    @IBAction func didChangeTimeOutValue(_ sender: Any) {
        SettingsBundleKeys.setTimeoutPref(timeout: Int(timeOutSlider.value))
        timeOutValue.text = String(Int(timeOutSlider.value))
        DriveKitTripAnalysis.shared.setStopTimeOut(timeOut: Int(timeOutSlider.value))
    }
    
    @IBAction func didChangeBeaconValue(_ sender: Any) {
        SettingsBundleKeys.setBeaconPref(required: beaconSwitch.isOn)
        DriveKitTripAnalysis.shared.setBeaconRequired(required: beaconSwitch.isOn)
    }
    
    @IBAction func didChangeBeaconConfigValue(_ sender: Any) {
        SettingsBundleKeys.setBeaconConfigPref(configurable: beaconConfigurationSwitch.isOn)
        
    }
    
    @IBAction func didChangePositionValue(_ sender: Any) {
        SettingsBundleKeys.setPositionPref(share: positionSwitch.isOn)
        DriveKitTripAnalysis.shared.enableSharePosition(enable: positionSwitch.isOn)
    }
    
    
}

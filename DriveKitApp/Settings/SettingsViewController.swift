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
    @IBOutlet var autoStartSwitch: UISwitch!
    @IBOutlet var timeOutSlider: UISlider!
    @IBOutlet var beaconSwitch: UISwitch!
    @IBOutlet var beaconConfigurationSwitch: UISwitch!
    @IBOutlet var positionSwitch: UISwitch!
    @IBOutlet var userIdLabel: UILabel!
    
    @IBOutlet var loggingTitle: UILabel!
    @IBOutlet var loggingDescription: UILabel!
    @IBOutlet var autoStartTitle: UILabel!
    @IBOutlet var autoStartDescription: UILabel!
    @IBOutlet var timeoutTitle: UILabel!
    @IBOutlet var beaconRequiredTitle: UILabel!
    @IBOutlet var beaconRequiredDescription: UILabel!
    @IBOutlet var beaconConfiguration: UILabel!
    @IBOutlet var sharePositionTitle: UILabel!
    @IBOutlet var sharePositionDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.configuretext()
    }
    
    func setup() {
        timeOutValue.text = String(SettingsBundleKeys.getTimeoutPref())
        loggingSwitch.isOn = SettingsBundleKeys.getLoggingPref()
        autoStartSwitch.isOn = SettingsBundleKeys.getAutoStartPref()
        timeOutSlider.value = Float(SettingsBundleKeys.getTimeoutPref())
        beaconSwitch.isOn = SettingsBundleKeys.getBeaconPref()
        beaconConfigurationSwitch.isOn = SettingsBundleKeys.getBeaconConfigPref()
        positionSwitch.isOn = SettingsBundleKeys.getPositionPref()
        userIdLabel.text = "\("user_id_title".keyLocalized()) : \(SettingsBundleKeys.getUserId() ?? "")"
    }
    
    private func configuretext(){
        loggingTitle.text = "enable_logging_title".keyLocalized()
        loggingDescription.text = "enable_logging_pref_off".keyLocalized()
        autoStartTitle.text = "autostart_title".keyLocalized()
        autoStartDescription.text = "auto_start_off".keyLocalized()
        timeoutTitle.text = "stop_timeout_title".keyLocalized()
        beaconRequiredTitle.text = "beacon_required_title".keyLocalized()
        beaconRequiredDescription.text = "beacon_required_on".keyLocalized()
        beaconConfiguration.text = "add_beacon_title".keyLocalized()
        sharePositionTitle.text = "enable_share_position_title".keyLocalized()
        sharePositionDescription.text = "enable_share_position_on".keyLocalized()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            
            let alert = UIAlertController(title: "user_id_title".keyLocalized(), message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.keyboardType = UIKeyboardType.default
                textField.text = SettingsBundleKeys.getUserId() ?? ""
            })
            
            let save = UIAlertAction(title: "OK", style: .default, handler: { _ in
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
        userIdLabel.text = "\("user_id_title".keyLocalized()) : \(SettingsBundleKeys.getUserId() ?? "")"
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
        var beacons : [BeaconData] = []
        if  UserDefaults.standard.bool(forKey: SettingsBundleKeys.beaconConfigurationPref)  {
            beacons.append(BeaconData(proximityUuid: "699ebc80-e1f3-11e3-9a0f-0cf3ee3bc012"))
        }
        DriveKitTripAnalysis.shared.setBeacons(beacons: beacons)
    }
    
    @IBAction func didChangePositionValue(_ sender: Any) {
        SettingsBundleKeys.setPositionPref(share: positionSwitch.isOn)
        DriveKitTripAnalysis.shared.enableSharePosition(enable: positionSwitch.isOn)
    }
    
    
}

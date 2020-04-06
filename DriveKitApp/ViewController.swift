//
//  ViewController.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 22/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverData
import DriveKitDriverDataUI
import DriveKitTripAnalysis
import CoreLocation
import CoreMotion
import DriveKitCommonUI
import DriveKitVehicleUI
import DriveKitVehicle
import DriveKitDBVehicleAccess

class ViewController: UITableViewController {
    
    @IBOutlet var startTripButton: UIButton!
    @IBOutlet var stopTripButton: UIButton!
    @IBOutlet var cancelTripButton: UIButton!
    
    @IBOutlet var driverDataExplanation: UILabel!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var motionButton: UIButton!
    @IBOutlet var notificationButton: UIButton!
    
    
    let location = CLLocationManager()
    let motion = CMMotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTripAnalysisButton()
        configureText()
    }
    
    private func configureText(){
        startTripButton.setTitle("start_trip".keyLocalized(), for: .normal)
        stopTripButton.setTitle("stop_trip".keyLocalized(), for: .normal)
        cancelTripButton.setTitle("cancel_trip".keyLocalized(), for: .normal)
        
        locationButton.setTitle("location_permission".keyLocalized(), for: .normal)
        motionButton.setTitle("activity_permission".keyLocalized(), for: .normal)
        notificationButton.setTitle("notification_permission".keyLocalized(), for: .normal)
        
        driverDataExplanation.text = "driver_data_explanation".keyLocalized()
    }
    
    private func configureTripAnalysisButton(){
        let tripAnalysisState = DriveKitTripAnalysis.shared.getRecorderState()
        switch tripAnalysisState {
        case .inactive:
            stopTripButton.isEnabled = false
            startTripButton.isEnabled = true
            cancelTripButton.isEnabled = false
        case .starting:
            stopTripButton.isEnabled = false
            startTripButton.isEnabled = false
            cancelTripButton.isEnabled = true
        case .running:
            stopTripButton.isEnabled = true
            startTripButton.isEnabled = false
            cancelTripButton.isEnabled = true
        case .stopping:
            stopTripButton.isEnabled = true
            startTripButton.isEnabled = false
            cancelTripButton.isEnabled = true
        case .sending:
            stopTripButton.isEnabled = false
            startTripButton.isEnabled = false
            cancelTripButton.isEnabled = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && indexPath.section == 0 {
            self.configureDriverDataUI()
        }else if indexPath.row == 3 && indexPath.section == 0 {
            self.configureDriverStreak()
        }else if indexPath.row == 4 && indexPath.section == 0 {
            self.configureVehiclePicker()
        }else if indexPath.row == 5 && indexPath.section == 0 {
            self.configureBeaconPairing()
        } else if indexPath.row == 6 && indexPath.section == 0 {
            self.configureVehiclesList()
        }
    }
    
    @IBAction func didTouchLocalization(_ sender: Any) {
        if #available(iOS 13.0, *) {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                location.requestWhenInUseAuthorization()
            } else {
                self.alertAuthorizations()
            }
        } else {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                location.requestAlwaysAuthorization()
            } else {
                self.alertAuthorizations()
            }
        }
        
    }
    
    @IBAction func didTouchActivity(_ sender: Any) {
        if #available(iOS 11.0, *) {
            if CMMotionActivityManager.authorizationStatus() == .notDetermined {
                motion.startActivityUpdates(to: .main, withHandler: { _ in })
            } else {
                self.alertAuthorizations()
            }
        } else {
            motion.startActivityUpdates(to: .main, withHandler: { _ in })
        }
    }
    
    @IBAction func didTouchNotification(_ sender: Any) {
        self.requestNotificationPermission()
    }
    
    private func requestNotificationPermission(){
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.getNotificationSettings(completionHandler: { (settings) in
            if(settings.authorizationStatus == .authorized)
            {
                DispatchQueue.main.async {
                    self.alertAuthorizations()
                }
            }
        })
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    
    func alertAuthorizations() {
        let alert = UIAlertController(title: "Request authorization", message: "The request authorization alert can be prompt only once. You have to go to the settings for authorization's update", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            guard #available(iOS 10, *) else {
                UIApplication.shared.openURL(settingsUrl)
                return
            }
            UIApplication.shared.open(settingsUrl)
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func configureDriverDataUI() {
        DispatchQueue.main.async {
            
            let tripListVC = TripListVC()
            self.navigationController?.pushViewController(tripListVC, animated: true)
        }
    }
    
    func configureDriverStreak() {
        if let driverAchievementUI = DriveKitNavigationController.shared.driverAchievementUI {
            let streakVC = driverAchievementUI.getStreakViewController()
            self.navigationController?.pushViewController(streakVC, animated: true)
        }
    }
    func configureVehiclePicker() {
        DispatchQueue.main.async {
           _ = DKVehiclePickerNavigationController(parentView: self)
        }
    }
    
    func configureBeaconPairing() {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(type: .cache, completionHandler: {[unowned self]status, vehicles in
            DispatchQueue.main.async {
                var uuid : String? = nil
                for vehicle in vehicles {
                    if let beacon = vehicle.beacon {
                        uuid = beacon.proximityUuid
                        break
                    }
                }
                if let proxUuid = uuid {
                    let beacon = DKBeacon(uniqueId: nil, proximityUuid: proxUuid, major: -1, minor: -1)
                    let viewModel = BeaconViewModel(scanType: .diagnostic, beacon: beacon, vehicles: vehicles)
                    self.navigationController?.pushViewController(BeaconScannerVC(viewModel: viewModel, step: .initial, parentView: self), animated: true)
                } else {
                    let viewModel = BeaconViewModel(scanType: .diagnostic)
                    self.navigationController?.pushViewController(BeaconScannerVC(viewModel: viewModel, step: .beaconNotConfigured, parentView: self), animated: true)
                }
            }
        })
        
    }
    
    func configureVehiclesList(){
        DispatchQueue.main.async {
            let listVC = VehiclesListVC()
            self.navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    
    @IBAction func startTrip(_ sender: Any) {
        DriveKitTripAnalysis.shared.startTrip()
        configureTripAnalysisButton()
    }
    
    @IBAction func stopTrip(_ sender: Any) {
        DriveKitTripAnalysis.shared.stopTrip()
        configureTripAnalysisButton()
    }
    @IBAction func cancelTrip(_ sender: Any) {
        DriveKitTripAnalysis.shared.cancelTrip()
        configureTripAnalysisButton()
    }
}


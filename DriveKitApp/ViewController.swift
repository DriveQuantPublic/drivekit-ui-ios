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
import DriveKitDriverAchievementUI

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
            /*let tripListConfig = TripListViewConfig()
            
            let tripDetailConfig = TripDetailViewConfig()
            
            let tripListVC = TripListVC(config: tripListConfig, detailConfig: tripDetailConfig)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(tripListVC, animated: true)*/
            let streakVC = StreakViewController()
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(streakVC, animated: true)
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


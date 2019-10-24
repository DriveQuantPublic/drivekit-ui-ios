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
import CoreLocation
import CoreMotion

class ViewController: UITableViewController {
    
    let location = CLLocationManager()
    let motion = CMMotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            let tripListConfig = TripListViewConfig()
            
            let tripDetailConfig = TripDetailViewConfig()
            
            let tripListVC = TripListVC(config: tripListConfig, detailConfig: tripDetailConfig)
            self.navigationController?.pushViewController(tripListVC, animated: true)
        }
    }
    
}


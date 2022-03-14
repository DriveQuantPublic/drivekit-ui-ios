//
//  ViewController.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 22/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitDriverDataModule
import DriveKitDriverDataUI
import DriveKitTripAnalysisModule
import CoreLocation
import CoreMotion
import DriveKitCommonUI
import DriveKitVehicleUI
import DriveKitVehicleModule
import DriveKitDBVehicleAccessModule
import DriveKitPermissionsUtilsUI
import DriveKitTripSimulatorModule

class ViewController: UITableViewController {
    @IBOutlet private weak var startTripButton: UIButton!
    @IBOutlet private weak var stopTripButton: UIButton!
    @IBOutlet private weak var cancelTripButton: UIButton!
    @IBOutlet private weak var driverDataExplanation: UILabel!
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var motionButton: UIButton!
    @IBOutlet private weak var notificationButton: UIButton!
    @IBOutlet private weak var sensorsStateLabel: UILabel!
    @IBOutlet private weak var tripSimulationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationController = self.navigationController {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: DKUIColors.fontColorOnPrimaryColor.color
            ]
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundEffect = nil
                appearance.backgroundColor = DKUIColors.primaryColor.color
                appearance.titleTextAttributes = titleTextAttributes
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            } else if #available(iOS 13.0, *) {
                navigationController.navigationBar.standardAppearance.titleTextAttributes = titleTextAttributes
                navigationController.navigationBar.standardAppearance.backgroundColor = DKUIColors.primaryColor.color
            } else {
                navigationController.navigationBar.titleTextAttributes = titleTextAttributes
                navigationController.navigationBar.backgroundColor = DKUIColors.primaryColor.color
            }
        }
        self.title = "Sample app"
        configureTripAnalysisButton()
        configureText()
        sensorStateChanged()

        NotificationCenter.default.addObserver(self, selector: #selector(sensorStateChanged), name: .sensorStateChangedNotification, object: nil)
    }
    
    private func configureText() {
        startTripButton.setTitle("start_trip".keyLocalized(), for: .normal)
        stopTripButton.setTitle("stop_trip".keyLocalized(), for: .normal)
        cancelTripButton.setTitle("cancel_trip".keyLocalized(), for: .normal)
        
        locationButton.setTitle("location_permission".keyLocalized(), for: .normal)
        motionButton.setTitle("activity_permission".keyLocalized(), for: .normal)
        notificationButton.setTitle("notification_permission".keyLocalized(), for: .normal)
        
        driverDataExplanation.text = "driver_data_explanation".keyLocalized()
    }
    
    private func configureTripAnalysisButton() {
        let tripAnalysisState = DriveKitTripAnalysis.shared.getRecorderState()
        switch tripAnalysisState {
        case .inactive:
            stopTripButton.isEnabled = false
            startTripButton.isEnabled = true
            cancelTripButton.isEnabled = false
        case .starting, .running, .stopping:
            stopTripButton.isEnabled = true
            startTripButton.isEnabled = false
            cancelTripButton.isEnabled = true
        case .sending:
            stopTripButton.isEnabled = false
            startTripButton.isEnabled = false
            cancelTripButton.isEnabled = false
        @unknown default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                configureDriverDataUI()
            } else if indexPath.row == 2 {
                openSynthesisCards()
            } else if indexPath.row == 3 {
                openLastTripsView()
            } else if indexPath.row == 5 {
                configureVehiclesList()
            } else if indexPath.row == 6 {
                configureVehiclePicker()
            } else if indexPath.row == 8 {
                simulateTrip()
            } else if indexPath.row == 9 {
                configureDriverStreak()
            } else if indexPath.row == 10 {
                configureBeaconPairing()
            } else if indexPath.row == 11 {
                openOdometer()
            } else if indexPath.row == 12 {
                configureDriverBadges()
            } else if indexPath.row == 13 {
                showRanking()
            } else if indexPath.row == 14 {
                showChallenges()
            } else if indexPath.row == 15 {
                showActivationHours()
            }
        }
    }

    @IBAction func didTouchLocalization(_ sender: Any) {
        if DKDiagnosisHelper.shared.getPermissionStatus(.location) == .valid {
            self.alertAuthorizations()
        } else {
            DriveKitPermissionsUtilsUI.shared.showPermissionViews([.location], parentViewController: self.navigationController!) {
                self.showAlertMessage(title: "Location", message: "👍", back: false, cancel: false)
            }
        }
    }
    
    @IBAction func didTouchActivity(_ sender: Any) {
        if DKDiagnosisHelper.shared.getPermissionStatus(.activity) == .valid {
            self.alertAuthorizations()
        } else {
            DriveKitPermissionsUtilsUI.shared.showPermissionViews([.activity], parentViewController: self.navigationController!) {
                self.showAlertMessage(title: "Activity", message: "👍", back: false, cancel: false)
            }
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

    func openSynthesisCards() {
        self.navigationController?.pushViewController(SynthesisCardTest.getSynthesisCardViewController(), animated: true)
    }

    func openLastTripsView() {
        self.navigationController?.pushViewController(LastTripsViewTest(), animated: true)
    }

    private func simulateTrip() {
        let alert: UIAlertController
        let alertTitle = "Simulate trip"
        if DriveKitTripSimulator.shared.isSimulatingTrip {
            alert = UIAlertController(title: alertTitle, message: "Stop current trip?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { alertAction in
                DriveKitTripSimulator.shared.stop()
                self.updateTripSimulationButtonTitle()
            }))
        } else {
            alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Too short trip", style: .default, handler: { alertAction in
                DriveKitTripSimulator.shared.start(.shortTrip)
                self.updateTripSimulationButtonTitle()
            }))
            alert.addAction(UIAlertAction(title: "City Suburban - 15 minutes", style: .default, handler: { alertAction in
                DriveKitTripSimulator.shared.start(.mixedTrip)
                self.updateTripSimulationButtonTitle()
            }))
            alert.addAction(UIAlertAction(title: "City - 20 minutes", style: .default, handler: { alertAction in
                DriveKitTripSimulator.shared.start(.cityTrip)
                self.updateTripSimulationButtonTitle()
            }))
            alert.addAction(UIAlertAction(title: "Suburban - 30 minutes", style: .default, handler: { alertAction in
                DriveKitTripSimulator.shared.start(.suburbanTrip)
                self.updateTripSimulationButtonTitle()
            }))
            alert.addAction(UIAlertAction(title: "Highway - 55 minutes", style: .default, handler: { alertAction in
                DriveKitTripSimulator.shared.start(.highwayTrip)
                self.updateTripSimulationButtonTitle()
            }))
            alert.addAction(UIAlertAction(title: "Train trip", style: .default, handler: { alertAction in
                DriveKitTripSimulator.shared.start(.trainTrip)
                self.updateTripSimulationButtonTitle()
            }))
            alert.addAction(UIAlertAction(title: "Boat trip", style: .default, handler: { alertAction in
                DriveKitTripSimulator.shared.start(.boatTrip)
                self.updateTripSimulationButtonTitle()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func updateTripSimulationButtonTitle() {
        let buttonTitle: String
        if DriveKitTripSimulator.shared.isSimulatingTrip {
            buttonTitle = "⏹"
        } else {
            buttonTitle = "▶️"
        }
        self.tripSimulationButton.setTitle(buttonTitle, for: .normal)
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
        if let vehicleUI = DriveKitNavigationController.shared.vehicleUI {
            self.navigationController?.pushViewController(vehicleUI.getBeaconDiagnosticViewController(parentView: self), animated: true)
        }
    }
    
    func configureVehiclesList() {
        DispatchQueue.main.async {
            let listVC = VehiclesListVC()
            self.navigationController?.pushViewController(listVC, animated: true)
        }
    }

    func openOdometer() {
        if let navigationController = self.navigationController {
            let odometerVehicleList = DriveKitVehicleUI.shared.getOdometerUI()
            navigationController.pushViewController(odometerVehicleList, animated: true)
        }
    }

    func configureDriverBadges() {
        if let driverAchievementUI = DriveKitNavigationController.shared.driverAchievementUI {
            let badgesVC = driverAchievementUI.getBadgesViewController()
            self.navigationController?.pushViewController(badgesVC, animated: true)
        }
    }

    func showRanking() {
        if let driverAchievementUI = DriveKitNavigationController.shared.driverAchievementUI {
            let rankingVC = driverAchievementUI.getRankingViewController()
            self.navigationController?.pushViewController(rankingVC, animated: true)
        }
    }

    func showChallenges() {
        if let challengeUI = DriveKitNavigationController.shared.challengeUI {
            let challengeListVC = challengeUI.getChallengeListViewController()
            self.navigationController?.pushViewController(challengeListVC, animated: true)
        }
    }

    func showActivationHours() {
        if let tripAnalysisUI = DriveKitNavigationController.shared.tripAnalysisUI {
            let activationHoursVC = tripAnalysisUI.getWorkingHoursViewController()
            self.navigationController?.pushViewController(activationHoursVC, animated: true)
        }
    }
    @IBAction private func askOnboardingPermissions() {
        DriveKitPermissionsUtilsUI.shared.showPermissionViews([.location, .activity], parentViewController: self.navigationController!) {
            self.showAlertMessage(title: "Permissions", message: "👍", back: false, cancel: false)
        }
    }

    @IBAction private func showDiagnosis() {
        self.navigationController?.pushViewController(DriveKitPermissionsUtilsUI.shared.getDiagnosisViewController(), animated: true)
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

    @objc private func sensorStateChanged() {
        if DriveKitPermissionsUtilsUI.shared.hasError() {
            self.sensorsStateLabel.text = "❌"
        } else {
            self.sensorsStateLabel.text = "✅"
        }
    }
}

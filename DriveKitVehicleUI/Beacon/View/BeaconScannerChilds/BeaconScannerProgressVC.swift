//
//  BeaconScannerProgressVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import CoreLocation
import CoreBluetooth

class BeaconScannerProgressVC: UIViewController {
    
    @IBOutlet weak var progressViewTitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let viewModel: BeaconViewModel
    
    private var timer: Timer? = nil
    private var batteryTimer : Timer? = nil
    private let locationManager = CLLocationManager()
    private let kontaktBeaconHelper = KontaktBeaconHelper()
    private var isBeaconFound = false
    
    init(viewModel: BeaconViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BeaconScannerProgressVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureProgressView()
        progressViewTitleLabel.attributedText = "dk_vehicle_beacon_wait_scan".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(refreshProgress), userInfo: nil, repeats: true)
        startBeaconScan()
        self.kontaktBeaconHelper.startBatteryLevelRetrieval(completion: self.onBatteryLevel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        stopBeaconScan()
        stopMonitoringBatteryLevel()
    }
    
    private func stopMonitoringBatteryLevel() {
        self.kontaktBeaconHelper.stopBatteryLevelRetrieval()
    }
    
    @objc func refreshProgress() {
        progressView.progress += 1/1000
        if progressView.progress == 1 {
            timer?.invalidate()
            if isBeaconFound {
                batteryTimer?.invalidate()
                goToNextStep()
            }else{
                self.stopBeaconScan()
                self.stopMonitoringBatteryLevel()
                viewModel.updateScanState(step: .beaconNotFound)
            }
        }
    }
    
    private func configureProgressView() {
        progressView.progress = 0
        progressView.progressViewStyle = .bar
        progressView.layer.cornerRadius = 8
        progressView.layer.masksToBounds = true
        progressView.layer.borderColor = DKUIColors.primaryColor.color.cgColor
        progressView.layer.borderWidth = 1
        progressView.tintColor = DKUIColors.secondaryColor.color
    }
    
    private func startBeaconScan() {
        locationManager.delegate = self
        if let beacon = self.viewModel.beacon {
            if #available(iOS 13.0, *) {
                locationManager.startRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint(noMajorMinor: self.viewModel.scanType != .pairing))
            } else {
                locationManager.startRangingBeacons(in: beacon.toCLBeaconRegion(noMajorMinor: self.viewModel.scanType != .pairing))
            }
        }
    }
    
    private func stopBeaconScan() {
        if let beacon = self.viewModel.beacon {
            if #available(iOS 13.0, *) {
                locationManager.stopRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint(noMajorMinor: self.viewModel.scanType != .pairing))
            } else {
                locationManager.stopRangingBeacons(in: beacon.toCLBeaconRegion(noMajorMinor: self.viewModel.scanType != .diagnostic))
            }
        }
    }
    
    private func beaconFound(clBeacon: CLBeacon) {
        self.stopBeaconScan()
        if self.viewModel.scanType == .pairing {
            goToNextStep()
        }else{
            self.viewModel.clBeacon = clBeacon
            batteryTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToNextStep), userInfo: nil, repeats: false)
        }
    }

    private func onBatteryLevel(_ result: BeaconResult) {
        switch result {
            case let .success(_, batteryLevel):
                self.viewModel.beaconBattery = batteryLevel
            case .error:
                break
        }
        self.kontaktBeaconHelper.stopBatteryLevelRetrieval()
    }
    
    @objc private func goToNextStep() {
        self.timer?.invalidate()
        self.stopMonitoringBatteryLevel()
        DispatchQueue.main.async {
            switch self.viewModel.scanType {
            case .pairing:
                self.viewModel.showLoader()
                self.viewModel.checkVehiclePaired { [weak self] isSameVehicle in
                    DispatchQueue.main.async {
                        self?.viewModel.hideLoader()
                        if self?.viewModel.vehiclePaired != nil {
                            if isSameVehicle {
                                self?.showAlertMessage(title: "", message: "dk_vehicle_beacon_already_paired_to_vehicle".dkVehicleLocalized(), back: true, cancel: false, completion: {
                                    self?.viewModel.scanValidationFinished()
                                })
                            }else{
                                self?.viewModel.updateScanState(step: .beaconAlreadyPaired)
                            }
                        } else{
                            self?.viewModel.updateScanState(step: .success)
                        }
                    }
                }
            case .verify:
                if self.viewModel.isBeaconValid() {
                    self.viewModel.updateScanState(step: .verified)
                }else{
                    self.viewModel.updateScanState(step: .wrongBeacon)
                }
            case .diagnostic:
                if self.viewModel.vehicles.isEmpty {
                    self.viewModel.updateScanState(step: .verified)
                } else {
                    if let vehicle = self.viewModel.vehicleFromBeacon() {
                        self.viewModel.vehicle = vehicle
                        self.viewModel.updateScanState(step: .verified)
                    } else {
                        self.viewModel.updateScanState(step: .wrongBeacon)
                    }
                }
            }
        }
    }
}


extension BeaconScannerProgressVC : CLLocationManagerDelegate {
    @available(iOS 13.0, *)
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if !isBeaconFound && !beacons.isEmpty {
            isBeaconFound = true
            self.beaconFound(clBeacon: beacons[0])
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if !isBeaconFound && !beacons.isEmpty{
            isBeaconFound = true
            self.beaconFound(clBeacon: beacons[0])
        }
    }
}

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

class BeaconScannerProgressVC: UIViewController {
    
    @IBOutlet weak var progressViewTitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let viewModel: BeaconViewModel
    
    private var timer: Timer? = nil
    private let locationManager = CLLocationManager()
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
        progressViewTitleLabel.text = "dk_vehicle_beacon_wait_scan".dkVehicleLocalized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(refreshProgress), userInfo: nil, repeats: true)
        startBeaconScan()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        stopBeaconScan()
    }
    
    @objc func refreshProgress() {
        progressView.progress += 1/1000
        if progressView.progress == 1 {
            timer?.invalidate()
            viewModel.updateScanState(step: .beaconNotFound)
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
                locationManager.startRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint())
            } else {
                locationManager.startRangingBeacons(in: beacon.toCLBeaconRegion())
            }
        }
    }
    
    private func stopBeaconScan() {
        if let beacon = self.viewModel.beacon {
            if #available(iOS 13.0, *) {
                locationManager.stopRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint())
            } else {
                locationManager.stopRangingBeacons(in: beacon.toCLBeaconRegion())
            }
        }
    }
    
    private func beaconFound() {
        timer?.invalidate()
        self.stopBeaconScan()
        DispatchQueue.main.async {
            self.viewModel.showLoader()
            self.viewModel.checkVehiclePaired { isSameVehicle in
                DispatchQueue.main.async {
                    self.viewModel.hideLoader()
                    if self.viewModel.vehiclePaired != nil {
                        if isSameVehicle {
                            self.showAlertMessage(title: "", message: "dk_vehicle_beacon_already_paired_to_vehicle".dkVehicleLocalized(), back: true, cancel: false, completion: {
                                self.viewModel.scanValidationFinished()
                            })
                        }else{
                            self.viewModel.updateScanState(step: .beaconAlreadyPaired)
                        }
                    } else{
                        self.viewModel.updateScanState(step: .success)
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
            self.beaconFound()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if !isBeaconFound && !beacons.isEmpty{
            isBeaconFound = true
            self.beaconFound()
        }
    }
}

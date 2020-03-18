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
    private var centralManager : CBCentralManager!
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
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        startBeaconScan()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        stopBeaconScan()
        stopMonitoringBatteryLevel()
    }
    
    private func stopMonitoringBatteryLevel() {
        self.centralManager.stopScan()
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
    
    @objc private func goToNextStep() {
        self.timer?.invalidate()
        self.stopMonitoringBatteryLevel()
        DispatchQueue.main.async {
            switch self.viewModel.scanType {
            case .pairing:
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
            case .verify:
                if self.viewModel.isBeaconValid() {
                    self.viewModel.updateScanState(step: .verified)
                }else{
                    self.viewModel.updateScanState(step: .wrongBeacon)
                }
            case .diagnostic:
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


extension BeaconScannerProgressVC: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        guard let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? Dictionary<CBUUID, Data> else {
            return
        }
        
        // Kontakt.io Beacon data from old advertismentData
        if let ktkOldData = serviceData[CBUUID(string:"D00D")] {
            // parse identifier get byte 0 - 6
            guard let _ = String(data: ktkOldData.subdata(in: Range(0...4)), encoding: String.Encoding.ascii) else {
                return
            }
            
            // parse battery level get byte 6
            var power: UInt8 = 0
            ktkOldData.copyBytes(to: &power, from: 6..<7)
            
            self.viewModel.beaconBattery = Int(power)
            self.stopMonitoringBatteryLevel()
        }
        
        // Kontakt.io Beacon data from new (pro beacons) advertismentData
        if let ktkNewData = serviceData[CBUUID(string:"FE6A")] {
            
            // parse battery level get byte 4
            var power: UInt8 = 0
            ktkNewData.copyBytes(to: &power, from: 4..<5)
            
            // parse identifier get byte 6 - 9
            guard let _ = String(data: ktkNewData.subdata(in: Range(6...9)), encoding: String.Encoding.ascii) else {
                return
            }
            self.viewModel.beaconBattery = Int(power)
            
            self.stopMonitoringBatteryLevel()
        }
    }
}

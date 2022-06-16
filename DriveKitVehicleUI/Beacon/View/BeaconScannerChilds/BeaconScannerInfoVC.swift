//
//  BeaconScannerInfoVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 17/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import CoreLocation
import DriveKitDBVehicleAccessModule

class BeaconScannerInfoVC: UIViewController {
    @IBOutlet weak var vehicleTitleLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var distanceContainerView: UIView!
    @IBOutlet weak var batteryContainerView: UIView!
    @IBOutlet weak var signalContainerView: UIView!
    @IBOutlet weak var startView: UIView!
    
    private let distanceIndicatorView = PicturedIndicatorView.viewFromNib
    private let batteryIndicatorView = PicturedIndicatorView.viewFromNib
    private let signalIndicatorView = PicturedIndicatorView.viewFromNib
    
    private let viewModel: BeaconViewModel
    private let valid: Bool
    
    init(viewModel: BeaconViewModel, valid: Bool) {
        self.viewModel = viewModel
        self.valid = valid
        super.init(nibName: "BeaconScannerInfoVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distanceContainerView.embedSubview(distanceIndicatorView)
        signalContainerView.embedSubview(signalIndicatorView)
        configure()
    }
    
    func configure() {
        if valid {
            vehicleTitleLabel.attributedText = self.viewModel.vehicleName.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
            startView.backgroundColor = DKUIColors.secondaryColor.color
        } else {
            vehicleTitleLabel.attributedText = "dk_beacon_vehicle_unknown".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
            startView.backgroundColor = .darkGray
        }
        if let clBeacon = self.viewModel.clBeacon {
            let major = "\(clBeacon.major)".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
            majorLabel.attributedText = "\("dk_vehicle_beacon_major".dkVehicleLocalized()) %@".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(major)
            let minor = "\(clBeacon.minor)".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
            minorLabel.attributedText = "\("dk_vehicle_beacon_minor".dkVehicleLocalized()) %@".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(minor)
            
            
            if let distance = self.viewModel.beaconDistance {
                distanceIndicatorView.configure(title: distance.formatMeterDistance(), image: UIImage(named: "dk_beacon_distance", in: .vehicleUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
            }
            let rssi: Int
            if let beaconRssi = self.viewModel.beaconRssi {
                rssi = Int(beaconRssi)
            } else {
                rssi = clBeacon.rssi
            }
            signalIndicatorView.configure(title: "\(rssi) dBm", image: UIImage(named: "dk_beacon_signal", in: .vehicleUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
        }
        if let level = viewModel.beaconBattery {
            batteryContainerView.embedSubview(batteryIndicatorView)
            batteryIndicatorView.configure(title: "\(level) %", image: batteryImage(level: level))
        }

        infoImageView.image = DKImages.info.image
        infoImageView.tintColor = DKUIColors.secondaryColor.color
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showBeaconDetail))
        infoImageView.isUserInteractionEnabled = true
        infoImageView.addGestureRecognizer(singleTap)
    }
    
    @objc private func showBeaconDetail() {
        if let beacon = self.viewModel.clBeacon {
            let battery: String
            if let batteryLevel = self.viewModel.beaconBattery {
                battery = "\(batteryLevel) %"
            } else {
                battery = "--"
            }
            let vehicle: DKVehicle? = valid ? self.viewModel.vehicle : nil
            let beaconDetailViewModel = BeaconDetailViewModel(vehicle: vehicle, beacon: beacon, batteryLevel: battery, distance: self.viewModel.beaconDistance, rssi: self.viewModel.beaconRssi, txPower: self.viewModel.beaconTxPower)
            self.navigationController?.pushViewController(BeaconDetailVC(viewModel: beaconDetailViewModel), animated: true)
        }
        
    }
    
    private func batteryImage(level: Int) -> UIImage? {
        let imageName: String
        if level <= 25 {
            imageName = "dk_beacon_battery_25"
        } else if level <= 50 {
            imageName = "dk_beacon_battery_50"
        } else if level <= 75 {
            imageName = "dk_beacon_battery_75"
        } else {
            imageName = "dk_beacon_battery_100"
        }
        return UIImage(named: imageName, in: .vehicleUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
}

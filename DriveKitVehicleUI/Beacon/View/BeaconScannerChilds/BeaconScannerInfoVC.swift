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
    
    private let viewModel : BeaconViewModel
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
        }else{
            vehicleTitleLabel.attributedText = "dk_beacon_vehicle_unknown".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
            startView.backgroundColor = .darkGray
        }
        if let clBeacon = self.viewModel.clBeacon {
            let major = "\(clBeacon.major)".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
            majorLabel.attributedText = "\("dk_vehicle_beacon_major".dkVehicleLocalized()) %@".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(major)
            let minor = "\(clBeacon.minor)".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
            minorLabel.attributedText = "\("dk_vehicle_beacon_major".dkVehicleLocalized()) %@".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(minor)
            
            
            if clBeacon.accuracy != -1 {
                distanceIndicatorView.configure(title: clBeacon.accuracy.formatMeterDistance(), image: UIImage(named: "dk_beacon_distance", in: .vehicleUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
            }
            signalIndicatorView.configure(title: "\(clBeacon.rssi) dBm", image: UIImage(named: "dk_beacon_signal", in: .vehicleUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
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
            var battery = "--"
            if let batteryLevel = self.viewModel.beaconBattery {
                battery = "\(batteryLevel) %"
            }
            let beaconDetailViewModel = BeaconDetailViewModel(vehicle: self.viewModel.vehicle, beacon: beacon, batteryLevel: battery)
            self.navigationController?.pushViewController(BeaconDetailVC(viewModel: beaconDetailViewModel), animated: true)
        }
        
    }
    
    private func batteryImage(level: Int) -> UIImage? {
        var imageName = "dk_beacon_battery_100"
        if level <= 25 {
            imageName = "dk_beacon_battery_25"
        }else if level <= 50 {
            imageName = "dk_beacon_battery_50"
        } else if level <= 75 {
            imageName = "dk_beacon_battery_75"
        }
        return UIImage(named: imageName, in: .vehicleUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
}

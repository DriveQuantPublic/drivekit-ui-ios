// swiftlint:disable all
//
//  BeaconStep.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

public enum BeaconStep {

    case initial
    case scan
    case success
    case beaconNotFound
    case beaconAlreadyPaired
    case congrats
    case beaconUnavailable
    case verified
    case wrongBeacon
    case beaconNotConfigured

    func title(viewModel: BeaconViewModel) -> NSAttributedString {
        var beaconCode = NSMutableAttributedString(string: "")
        if let beaconId = viewModel.beacon?.uniqueId {
            beaconCode = beaconId.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
        }
        let vehicleName = viewModel.vehicleName.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
        
        switch self {
        case .initial:
            return "dk_vehicle_beacon_start_scan".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        case .scan:
            return "dk_vehicle_beacon_setup_scan_title".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        case .success:
            return "dk_vehicle_beacon_setup_code_success_message".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        case .beaconNotFound:
            if viewModel.scanType == .pairing {
                return "dk_vehicle_beacon_setup_code_not_matched".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(beaconCode)
            } else {
                return "dk_beacon_not_seen".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
            }
        case .beaconAlreadyPaired:
            return "dk_vehicle_beacon_already_paired".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        case .congrats:
            return "dk_vehicle_beacon_setup_successlink_message".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(beaconCode, vehicleName)
        case .verified:
                return "dk_vehicle_beacon_setup_code_success_message".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        case .wrongBeacon:
                return "dk_vehicle_beacon_verify_wrong_vehicle".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        case .beaconUnavailable:
            return "dk_vehicle_beacon_setup_code_unavailable_id".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(beaconCode)
        case .beaconNotConfigured:
            return "dk_vehicle_beacon_diagnostic_alert".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        }
    }
    
    func description(viewModel: BeaconViewModel) -> NSAttributedString {
        switch self {
        case .success:
            var beaconCode = NSMutableAttributedString(string: "")
            if let beaconId = viewModel.beacon?.uniqueId {
                beaconCode = beaconId.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
            }
            let vehicleName = viewModel.vehicleName.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
            return "dk_vehicle_beacon_setup_code_success_recap".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(beaconCode, vehicleName)
        case .congrats:
            return "dk_vehicle_beacon_setup_store_notice".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        default:
            return NSAttributedString(string: "")
        }
    }
    
    var confirmButtonText: String {
        switch self {
        case .success:
            return DKCommonLocalizable.confirm.text()
        case .congrats:
            return DKCommonLocalizable.finish.text()
        default:
            return ""
        }
    }

    var image: UIImage? {
        switch self {
        case .initial:
            return DKVehicleImages.beaconStart.image
        case .scan:
            return DKVehicleImages.beaconScanRunning.image
        case .success:
            return DKVehicleImages.beaconOk.image
        case .beaconNotFound, .beaconAlreadyPaired, .beaconUnavailable, .beaconNotConfigured:
            return DKVehicleImages.beaconNotFound.image
        case .congrats:
            return DKVehicleImages.vehicleCongrats.image
        case .verified:
            return DKVehicleImages.beaconOk.image
        case .wrongBeacon:
            return DKVehicleImages.beaconNotFound.image
        }
    }
    
    func viewController(viewModel: BeaconViewModel) -> UIViewController? {
        switch self {
        case .initial:
            return nil
        case .scan:
            return BeaconScannerProgressVC(viewModel: viewModel)
        case .success, .congrats:
            return BeaconScannerSuccessVC(viewModel: viewModel, step: self)
        case .beaconNotFound:
            return BeaconScanFailureVC(viewModel: viewModel)
        case .verified:
            return BeaconScannerInfoVC(viewModel: viewModel, valid: true)
        case .wrongBeacon:
            return BeaconScannerInfoVC(viewModel: viewModel, valid: false)
        case .beaconAlreadyPaired:
            return BeaconScannerAlreadyPairedVC(viewModel: viewModel)
        case .beaconUnavailable:
            return BeaconScannerBeaconUnavailableVC(viewModel: viewModel)
        case .beaconNotConfigured:
            return BeaconScannerNotConfiguredVC(viewModel: viewModel)
        }
    }
    
    func onImageClicked(viewModel: BeaconViewModel) {
        switch self {
        case .initial, .beaconNotFound:
            viewModel.updateScanState(step: .scan)
        default:
            break
        }
    }
}

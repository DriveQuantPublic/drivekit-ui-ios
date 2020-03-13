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

    //case initial
    case scan
    case success
    case beaconNotFound
    case beaconAlreadyPaired
    case congrats
    case beaconUnavailable
    //case verify
    //case unknown

    var title: String {
        switch self {
       // case .initial:
           // return "beacon_start_scan".dkVehicleLocalized()
        case .scan:
            return "dk_vehicle_beacon_setup_scan_title".dkVehicleLocalized()
        case .success:
            return "dk_vehicle_beacon_setup_code_success_message".dkVehicleLocalized()
        case .beaconNotFound:
            return "dk_vehicle_beacon_setup_code_not_matched".dkVehicleLocalized()
        case .beaconAlreadyPaired:
            return "dk_vehicle_beacon_already_paired".dkVehicleLocalized()
        case .congrats:
            return "dk_vehicle_beacon_setup_congrats".dkVehicleLocalized()
        /*case .verify:
            return "beacon_verify_wrong_vehicle".dkVehicleLocalized()
        case .unknown:
            return "beacon_scan_wrong_beacon".dkVehicleLocalized()*/
        case .beaconUnavailable:
            return "dk_vehicle_beacon_setup_code_unavailable_id".dkVehicleLocalized()
        }
    }
    
    var description : String {
        switch self {
        case .success:
            return "dk_vehicle_beacon_setup_code_success_recap".dkVehicleLocalized()
        case .congrats:
            return "dk_vehicle_beacon_setup_congrats_recap".dkVehicleLocalized()
        default:
            return ""
        }
    }
    
    var confirmButtonText : String {
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
        //case .initial:
           // return nil
        case .scan:
            return UIImage(named: "dk_beacon_scan_running", in: .vehicleUIBundle, compatibleWith: nil)
        case .success:
            return UIImage(named: "dk_beacon_ok", in: .vehicleUIBundle, compatibleWith: nil)
        case .beaconNotFound, .beaconAlreadyPaired, .beaconUnavailable:
            return UIImage(named: "dk_beacon_not_found", in: .vehicleUIBundle, compatibleWith: nil)
        case .congrats:
            return UIImage(named: "dk_vehicle_congrats", in: .vehicleUIBundle, compatibleWith: nil)
        /*case .verify:
            return nil
        case .unknown:
            return nil*/
        }
    }
    
    func viewController(viewModel: BeaconViewModel) -> UIViewController? {
        switch self {
        //case .initial:
           // return nil
        case .scan:
            return BeaconScannerProgressVC(viewModel: viewModel)
        case .success, .congrats:
            return BeaconScannerSuccessVC(viewModel: viewModel, step: self)
        case .beaconNotFound:
            return BeaconScanFailureVC(viewModel: viewModel)
        /*case .verify:
            return nil
        case .unknown:
            return nil*/
        case .beaconAlreadyPaired:
            return BeaconScannerAlreadyPairedVC(viewModel: viewModel)
        case .beaconUnavailable:
            return BeaconScannerBeaconUnavailableVC(viewModel: viewModel)
        }
    }
}

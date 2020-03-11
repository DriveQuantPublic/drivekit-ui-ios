//
//  BeaconStep.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

enum BeaconStep {

    //case initial
    case scan
    case success
    case failure
    case beaconAlreadyPaired
    case congrats
    //case verify
    //case unknown

    var title: String {
        switch self {
       // case .initial:
           // return "beacon_start_scan".dkVehicleLocalized()
        case .scan:
            return "beacon_scan_running".dkVehicleLocalized()
        case .success:
            return "beacon_scan_success".dkVehicleLocalized()
        case .failure:
            return "beacon_scan_failed".dkVehicleLocalized()
        case .beaconAlreadyPaired:
            return "beacon_already_paired".dkVehicleLocalized()
        case .congrats:
            return "beacon_setup_congrats".dkVehicleLocalized()
        /*case .verify:
            return "beacon_verify_wrong_vehicle".dkVehicleLocalized()
        case .unknown:
            return "beacon_scan_wrong_beacon".dkVehicleLocalized()*/
        }
    }
    
    var description : String {
        switch self {
        case .success:
            return "confirm_pairing".dkVehicleLocalized()
        case .congrats:
            return "success_pairing".dkVehicleLocalized()
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
            return nil
        case .success:
            return nil
        case .failure:
            return nil
        case .congrats:
            return nil
        /*case .verify:
            return nil
        case .unknown:
            return nil*/
        case .beaconAlreadyPaired:
            return nil
        }
    }
    
    func viewController(viewModel: BeaconViewModel) -> UIViewController? {
        switch self {
        //case .initial:
           // return nil
        case .scan:
            return BeaconScannerProgressVC(viewModel: viewModel)
        case .success, .congrats:
            return BeaconScannerValidateVC(viewModel: viewModel, step: self)
        case .failure:
            return BeaconFailureVC(viewModel: viewModel)
        /*case .verify:
            return nil
        case .unknown:
            return nil*/
        case .beaconAlreadyPaired:
            return BeaconScannerAlreadyPairedVC(viewModel: viewModel)
        }
    }
}

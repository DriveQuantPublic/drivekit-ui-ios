//
//  ActivationHoursViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 17/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule

class ActivationHoursViewModel {
    let sections: [ActivationHoursSection] = [
        .separator,
        .slot,
        .separator,
        .slot,
        .separator,
        .day,
        .day,
        .day,
        .day,
        .day,
        .day,
        .day
    ]
    private var activationHours: DKActivationHours?
    public weak var delegate: DKActivationHoursConfigDelegate? = nil

    func synchronizeActivationHours() {
        self.delegate?.showLoader()
        DriveKitTripAnalysis.shared.getActivationHours { [weak self] status, activationHours in
            if let self = self {
                self.activationHours = activationHours
                if status == .success {
                    self.delegate?.hideLoader()
                    self.delegate?.onActivationHoursAvaiblale()
                } else {
                    self.delegate?.didReceiveErrorFromService()
                }
            }
        }
    }

//    func buildActivationHours() -> DKActivationHours {
//        return DKActivationHours(
//            enabled: <#T##Bool#>,
//            activationHoursDayConfigurations: <#T##[DKActivationHoursDayConfiguration]#>,
//            outsideHours: <#T##Bool#>)
//    }
}

public protocol DKActivationHoursConfigDelegate: AnyObject {
    func onActivationHoursAvaiblale()
    func onActivationHoursUpdated()
    func didReceiveErrorFromService()
    func showLoader()
    func hideLoader()
}

enum ActivationHoursSection {
    case separator
    case slot
    case day
}

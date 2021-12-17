//
//  ActivationHoursViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 17/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule

public class ActivationHoursViewModel {
    private var activationHours: DKActivationHours?
    public weak var delegate: DKActivationHoursConfigDelegate? = nil

    func synchronizeActivationHours() {
        self.delegate?.showLoader()
        DriveKitTripAnalysis.shared.getActivationHours {[weak self] status, activationHours in
            self?.activationHours = activationHours
            if status == .success {
                self?.delegate?.hideLoader()
                self?.delegate?.onActivationHoursAvaiblale()
            } else {
                self?.delegate?.didReceiveErrorFromService()
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


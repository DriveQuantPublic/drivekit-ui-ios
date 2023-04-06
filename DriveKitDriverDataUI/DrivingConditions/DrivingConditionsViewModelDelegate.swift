//
//  DrivingConditionsViewModelDelegate.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import Foundation

protocol DrivingConditionsViewModelDelegate: AnyObject {
    func willUpdateData()
    func didUpdateData()
}

protocol DrivingConditionsViewModelParentDelegate: AnyObject {
    func didUpdate(selectedDate: Date)
    func didUpdate(selectedPeriod: DKPeriod)
}

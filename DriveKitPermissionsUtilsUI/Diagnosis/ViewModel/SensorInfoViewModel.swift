// swiftlint:disable all
//
//  SensorInfoViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 21/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class SensorInfoViewModel {
    let title: String
    let description: String
    let buttonTitle: String
    private let statusType: StatusType
    private let isValid: Bool
    private weak var diagnosisViewModel: DiagnosisViewModel?

    init(statusType: StatusType, isValid: Bool, diagnosisViewModel: DiagnosisViewModel) {
        self.statusType = statusType
        self.isValid = isValid
        self.diagnosisViewModel = diagnosisViewModel
        self.title = statusType.getTitle()
        if isValid {
            self.description = statusType.getValidDescription()
            self.buttonTitle = statusType.getValidAction()
        } else {
            self.description = statusType.getInvalidDescription()
            self.buttonTitle = statusType.getInvalidAction()
        }
    }

    func manageAction() {
        if let diagnosisViewModel = self.diagnosisViewModel {
            diagnosisViewModel.performDialogAction(for: self.statusType, isValid: self.isValid)
        }
    }
}

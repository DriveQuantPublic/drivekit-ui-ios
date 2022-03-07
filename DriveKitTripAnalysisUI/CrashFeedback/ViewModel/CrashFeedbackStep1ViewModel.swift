//
//  CrashFeedbackStep1ViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 07/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule

struct CrashFeedbackStep1ViewModel {
    var crashInfo: DKCrashInfo

    init(crashInfo: DKCrashInfo) {
        self.crashInfo = crashInfo
    }

    func sendNoCrash() {
        _ = DriveKitTripAnalysis.shared.noCrashConfirmationOpened(crashId: crashInfo.crashId)
    }

    func sendCriticalCrash() {
        DriveKitTripAnalysis.shared.sendCrashFeedback(
            crashInfo: crashInfo,
            feedback: CrashFeedbackType.confirmed,
            severity: CrashFeedbackSeverity.critical)
    }
}

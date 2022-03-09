//
//  CrashFeedbackStep1ViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 07/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule
import DriveKitCommonUI

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

    func getMessageAttributedText() -> NSAttributedString {
        let titleString = "dk_crash_detection_feedback_step1_title".dkTripAnalysisLocalized().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 25, traits: nil)).build()
        let descriptionString = "dk_crash_detection_feedback_step1_description".dkTripAnalysisLocalized().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 14, traits: nil)).color(DKUIColors.mainFontColor.color.withAlphaComponent(0.36)).build()
        return "%@\n\n%@".dkAttributedString().buildWithArgs(titleString, descriptionString)
    }

}

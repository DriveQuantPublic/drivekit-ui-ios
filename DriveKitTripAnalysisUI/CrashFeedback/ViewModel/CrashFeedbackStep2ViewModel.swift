//
//  CrashFeedbackStep2ViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 09/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule
import DriveKitCommonUI

struct CrashFeedbackStep2ViewModel {
    var crashInfo: DKCrashInfo

    init(crashInfo: DKCrashInfo) {
        self.crashInfo = crashInfo
    }

    func sendNoCrash() {
        DriveKitTripAnalysis.shared.sendCrashFeedback(
            crashInfo: crashInfo,
            feedback: CrashFeedbackType.noCrash,
            severity: CrashFeedbackSeverity.none)
    }

    func sendCriticalCrash() {
        DriveKitTripAnalysis.shared.sendCrashFeedback(
            crashInfo: crashInfo,
            feedback: CrashFeedbackType.confirmed,
            severity: CrashFeedbackSeverity.critical)
    }

    func sendMinorCrash() {
        DriveKitTripAnalysis.shared.sendCrashFeedback(
            crashInfo: crashInfo,
            feedback: CrashFeedbackType.confirmed,
            severity: CrashFeedbackSeverity.minor)
    }

    func getMessageAttributedText() -> NSAttributedString {
        let titleString = "dk_crash_detection_feedback_step2_title".dkTripAnalysisLocalized().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 25, traits: nil)).color(DKUIColors.mainFontColor.color).build()
        let descriptionString = "dk_crash_detection_feedback_step2_description".dkTripAnalysisLocalized().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 25, traits: nil)).color(DKUIColors.mainFontColor.color).build()
        return "%@\n\n%@".dkAttributedString().buildWithArgs(titleString, descriptionString)
    }

}

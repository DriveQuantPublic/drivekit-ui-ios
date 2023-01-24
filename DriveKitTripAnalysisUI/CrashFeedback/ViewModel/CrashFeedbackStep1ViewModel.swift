// swiftlint:disable all
//
//  CrashFeedbackStep1ViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 07/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitTripAnalysisModule
import DriveKitCommonUI

struct CrashFeedbackStep1ViewModel {
    private var crashInfo: DKCrashInfo

    init(crashInfo: DKCrashInfo) {
        self.crashInfo = crashInfo
    }

    func prepareStep2() -> DKCrashInfo? {
        return DriveKitTripAnalysis.shared.noCrashConfirmationOpened(crashId: crashInfo.crashId)
    }

    func sendCriticalCrash() {
        DriveKitTripAnalysis.shared.sendCrashFeedback(
            crashInfo: crashInfo,
            feedback: CrashFeedbackType.confirmed,
            severity: CrashFeedbackSeverity.critical)
    }

    func getMessageAttributedText() -> NSAttributedString {
        let titleString = "dk_crash_detection_feedback_step1_title".dkTripAnalysisLocalized().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 25, traits: nil)).color(DKUIColors.mainFontColor.color).build()
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.lineHeightMultiple = 0.85
        titleString.addAttributes([NSAttributedString.Key.paragraphStyle: titleParagraphStyle], range: NSRange(location: 0, length: titleString.length))

        let descriptionString = "dk_crash_detection_feedback_step1_description".dkTripAnalysisLocalized().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 14, traits: nil)).color(DKUIColors.mainFontColor.color.withAlphaComponent(0.36)).build()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.75
        descriptionString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: descriptionString.length))
        return "%@\n%@".dkAttributedString().buildWithArgs(titleString, descriptionString)
    }

}

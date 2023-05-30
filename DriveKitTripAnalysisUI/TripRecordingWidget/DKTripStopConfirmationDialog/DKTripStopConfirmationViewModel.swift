//
//  DKTripStopConfirmationViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Frédéric Ruaudel on 15/05/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import CoreLocation
import DriveKitCommonUI
import DriveKitTripAnalysisModule
import Foundation

public class DKTripStopConfirmationViewModel {
    init() { }
    
    var endTripTitle: String {
        "dk_tripwidget_confirm_endtrip_title".dkTripAnalysisLocalized()
    }
    
    var endTripSubtitle: String {
        "dk_tripwidget_confirm_endtrip_subtitle".dkTripAnalysisLocalized()
    }
    
    var continueTripTitle: String {
        "dk_tripwidget_confirm_continuetrip_title".dkTripAnalysisLocalized()
    }
    
    var continueTripSubtitle: String {
        "dk_tripwidget_confirm_continuetrip_subtitle".dkTripAnalysisLocalized()
    }
    
    var cancelTripTitle: String {
        "dk_tripwidget_confirm_canceltrip_title".dkTripAnalysisLocalized()
    }
    
    var cancelTripSubtitle: String {
        "dk_tripwidget_confirm_canceltrip_subtitle".dkTripAnalysisLocalized()
    }
    
    var disableRecordingConfirmationTitle: String {
        "dk_tripwidget_disable_autostart_title".dkTripAnalysisLocalized()
    }
    
    // swiftlint:disable no_magic_numbers
    var disableRecordingConfirmationTitlesAndDurations: [(String, Int)] {
        [
            (String(format: "10 %@", DKCommonLocalizable.minutePlural.text()), 10),
            (String(format: "30 %@", DKCommonLocalizable.minutePlural.text()), 30),
            (String(format: "1 %@", DKCommonLocalizable.hourSingular.text()), 60),
            (String(format: "2 %@", DKCommonLocalizable.hourPlural.text()), 120),
            (String(format: "4 %@", DKCommonLocalizable.hourPlural.text()), 240)
        ]
    }
    // swiftlint:enable no_magic_numbers

    func endTrip() {
        DriveKitTripAnalysis.shared.stopTrip()
    }
    
    func disableRecording(forDuration duration: Int) {
        DriveKitTripAnalysis.shared.temporaryDeactivateSDK(minutes: duration)
    }
}

//
//  DKCrashDetectionFeedbackConfig.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 07/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule

@objc public class DKCrashDetectionFeedbackConfig: NSObject {
    let config: DKCrashFeedbackConfig
    let roadsideAssistanceNumber: String

    public init(config: DKCrashFeedbackConfig, roadsideAssistanceNumber: String) {
        self.config = config
        self.roadsideAssistanceNumber = roadsideAssistanceNumber
    }
}

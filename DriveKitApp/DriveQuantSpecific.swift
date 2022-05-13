//
//  DriveQuantSpecific.swift
//  DriveKitApp
//
//  Created by David Bauduin on 10/05/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

// ======================================================
// WARNING: This class is specific to DriveQuant.
// DO NOT USE IT OR REPRODUCE THIS BEHAVIOUR IN YOUR APP.
// ======================================================
class DriveQuantSpecific {
    private static let driveQuantSpecificUserDefaults: UserDefaults? = UserDefaults(suiteName: "drivequant-specific")
    private static let apiKeyUserDefaultKey = "drivequant-specific-apikey-key"

    private init() {

    }

    static func initialize() {
        let processInfo = ProcessInfo.processInfo
        if let apiKey = processInfo.environment["DriveKit-API-Key"] {
            driveQuantSpecificUserDefaults?.set(apiKey, forKey: apiKeyUserDefaultKey)
        }
    }

    static func getSavedApiKey() -> String? {
        return driveQuantSpecificUserDefaults?.string(forKey: apiKeyUserDefaultKey)
    }
}

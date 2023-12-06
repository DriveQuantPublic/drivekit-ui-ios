//
//  Bundle+DK.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 02/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public extension Bundle {
    var appName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}

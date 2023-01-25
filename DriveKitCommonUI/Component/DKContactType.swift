// swiftlint:disable all
//
//  DKContactType.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 16/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public enum DKContactType {
    case none
    case email(DKContentMail)
    case web(URL)
}

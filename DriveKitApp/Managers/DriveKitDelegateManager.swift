//
//  DriveKitDelegateManager.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

class DriveKitDelegateManager: DriveKitDelegate {
    static let shared = DriveKitDelegateManager()

    private var delegates: WeakArray<DriveKitDelegate> = WeakArray()

    func registerDelegate(delegate: DriveKitDelegate) {
        delegates.append(delegate)
    }

    func unregisterDelegate(delegate: DriveKitDelegate) {
        delegates.remove(delegate)
    }

    func driveKitDidConnect(_ driveKit: DriveKit) {
        for delegate in delegates {
            delegate?.driveKitDidConnect(driveKit)
        }
    }

    func driveKitDidDisconnect(_ driveKit: DriveKit) {
        for delegate in delegates {
            delegate?.driveKitDidDisconnect(driveKit)
        }
    }

    func driveKit(_ driveKit: DriveKit, didReceiveAuthenticationError error: RequestError) {
        for delegate in delegates {
            delegate?.driveKit(driveKit, didReceiveAuthenticationError: error)
        }
    }

    func reset() {
        delegates = WeakArray()
    }
}

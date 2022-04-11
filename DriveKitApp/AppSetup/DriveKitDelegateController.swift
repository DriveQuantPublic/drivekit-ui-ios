//
//  DriveKitDelegateController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

class DriveKitDelegateController: DriveKitDelegate {

    private var delegates: WeakArray<DriveKitDelegateController> = WeakArray()

    func registerDelegate(delegate: DriveKitDelegateController) {
        delegates.append(delegate)
    }

    func unregisterDelegate(delegate: DriveKitDelegateController) {
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
    
    func driveKitDidReceiveAuthenticationError(_ driveKit: DriveKit) {
        for delegate in delegates {
            delegate?.driveKitDidReceiveAuthenticationError(driveKit)
        }
    }

    func reset() {
        delegates = WeakArray()
    }
}

//
//  DKMainDispatcher.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 25/10/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

extension DispatchQueue {
    public static func dispatchOnMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}

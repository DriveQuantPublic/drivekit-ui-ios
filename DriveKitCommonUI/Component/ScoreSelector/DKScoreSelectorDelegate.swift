//
//  DKScoreSelectorDelegate.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 17/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import Foundation

public protocol DKScoreSelectorDelegate: AnyObject {
    func scoreSelectorDidSelectScore(_ score: DKScoreType)
}

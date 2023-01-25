// swiftlint:disable all
//
//  DKGaugeConfiguration.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 28/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public protocol DKGaugeConfiguration {
    func getColor() -> UIColor
    func getGaugeType() -> DKGaugeType
    func getProgress() -> Double
    func getTitle() -> String
}

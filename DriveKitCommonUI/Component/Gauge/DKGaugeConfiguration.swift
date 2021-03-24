//
//  DKGaugeConfiguration.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 28/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public protocol DKGaugeConfiguration {
    func getColor() -> Int
    func getGaugeType() -> DKGaugeType
    func getProgress() -> Double
    func getTitle() -> String
}

extension ConfigurationCircularProgressView: DKGaugeConfiguration {
    public func getColor() -> Int {
        #warning("TODO")
        return 0
    }

    public func getGaugeType() -> DKGaugeType {
        #warning("TODO")
        return .open
    }

    public func getProgress() -> Double {
        #warning("TODO")
        return self.value / self.maxValue
    }

    public func getTitle() -> String {
        #warning("TODO")
        return "TODO"
    }
}

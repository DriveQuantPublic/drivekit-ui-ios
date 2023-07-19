// swiftlint:disable all
//
//  DKAnalytics.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 19/08/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public protocol DKAnalytics {
    func trackScreen(_ screen: String, viewController: UIViewController)
    func trackEvent(_ event: DKAnalyticsEvent, parameters: [String: Any]?)
}

extension DKAnalytics {
    public func logNonFatalError(
        _ message: String,
        parameters: [String: Any] = [:],
        _ function: StaticString = #function,
        _ file: StaticString = #fileID,
        _ line: Int = #line
    ) {
        var allParameters: [String: Any] = parameters
        allParameters[DKAnalyticsEventKey.errorMessage.rawValue] = "Non fatal error: \(message) in \(function) at \(file):\(line)"
        self.trackEvent(
            .nonFatalErrors,
            parameters: allParameters
        )
    }
}

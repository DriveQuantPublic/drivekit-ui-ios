//
//  DKAnalytics.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 19/08/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public protocol DKAnalytics {
    func track(screen: String, viewController: UIViewController)
}

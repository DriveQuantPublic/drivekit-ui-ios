//
//  DriveKitDriverDataUIEntryPoint.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 28/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public protocol DriveKitDriverDataUIEntryPoint {
    func getTripListViewController() -> UIViewController
    func getTripDetailViewController(itinId: String, showAdvice: Bool, alternativeTransport: Bool) -> UIViewController
    func getMySynthesisViewController() -> UIViewController
    func getDriverProfileViewController() -> UIViewController
    func getDrivingConditionsViewController() -> UIViewController
}

public extension DriveKitDriverDataUIEntryPoint {
    func getTripDetailViewController(itinId: String) -> UIViewController {
        return getTripDetailViewController(itinId: itinId, showAdvice: false, alternativeTransport: false)
    }
}

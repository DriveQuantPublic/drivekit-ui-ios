//
//  DriveKitTripAnalysisUI.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 16/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCommonUI

@objc public class DriveKitTripAnalysisUI: NSObject {

    @objc public static let shared = DriveKitTripAnalysisUI()
    private var activationHoursVC: ActivationHoursViewController?
    
    @objc public func initialize() {
        DriveKitNavigationController.shared.tripAnalysisUI = self
    }
}

extension DriveKitTripAnalysisUI: DriveKitTripAnalysisUIEntryPoint {
    public func getActivationHoursViewController() -> UIViewController {
        let activationHoursVC = ActivationHoursViewController()
        self.activationHoursVC = activationHoursVC
        return activationHoursVC

    }
}

extension Bundle {
    static let tripAnalysisUIBundle = Bundle(identifier: "com.drivequant.drivekit-trip-analysis-ui")
}

extension String {
    public func dkTripAnalysisLocalized() -> String {
        return self.dkLocalized(tableName: "DKTripAnalysisLocalizable", bundle: Bundle.tripAnalysisUIBundle ?? .main)
    }
}

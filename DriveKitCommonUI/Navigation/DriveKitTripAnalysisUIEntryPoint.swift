//
//  DriveKitTripAnalysisUIEntryPoint.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 16/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

public protocol DriveKitTripAnalysisUIEntryPoint {
    func getWorkingHoursViewController() -> UIViewController
}

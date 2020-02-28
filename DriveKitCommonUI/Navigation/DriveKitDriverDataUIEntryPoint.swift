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
    func getTripDetailViewController() -> UIViewController
}

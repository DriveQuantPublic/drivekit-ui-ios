//
//  DriveKitVehicleUIEntryPoint.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 26/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public protocol DriveKitVehicleUIEntryPoint {
    func getVehicleListViewController() -> UIViewController
    func getVehicleDetailViewController(vehicleId: String, completion: @escaping (UIViewController?) -> Void)
    func getVehicleNameWith(vehicleId: String, completion: @escaping (String?) -> Void)
    func getBeaconDiagnosticViewController(parentView: UIViewController) -> UIViewController
    func getVehicleFilterItems() -> [DKFilterItem]
}

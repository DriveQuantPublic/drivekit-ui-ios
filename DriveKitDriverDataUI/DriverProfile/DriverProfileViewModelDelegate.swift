//
//  DriverProfileViewModelDelegate.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 26/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation

protocol DriverProfileViewModelDelegate: AnyObject {
    func willUpdateData()
    func didUpdateData()
}

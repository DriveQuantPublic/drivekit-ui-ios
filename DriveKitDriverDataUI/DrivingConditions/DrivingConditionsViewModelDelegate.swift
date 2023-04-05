//
//  DrivingConditionsViewModelDelegate.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation

protocol DrivingConditionsViewModelDelegate: AnyObject {
    func willUpdateData()
    func didUpdateData()
}

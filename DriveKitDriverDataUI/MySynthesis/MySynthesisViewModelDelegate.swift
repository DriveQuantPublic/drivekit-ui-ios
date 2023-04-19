//
//  MySynthesisViewModelDelegate.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 20/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation

protocol MySynthesisViewModelDelegate: AnyObject {
    func willUpdateData()
    func didUpdateData()
}

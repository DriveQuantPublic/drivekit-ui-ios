//
//  VehiclePickerTableViewDelegate.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

// swiftlint:disable:next class_delegate_protocol
protocol VehiclePickerTableViewDelegate {
    func getTableViewItems(viewModel: VehiclePickerViewModel) -> [VehiclePickerTableViewItem]
    func onTableViewItemSelected(pos: Int, viewModel: VehiclePickerViewModel)
    func description() -> String?
}

protocol VehiclePickerTableViewItem {
    func text() -> String
}

//
//  VehiclePickerTableViewDelegate.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

protocol VehiclePickerTableViewDelegate {
    func getTableViewItems(viewModel : VehiclePickerViewModel) -> [VehiclePickerTableViewItem]
    func onTableViewItemSelected(pos: Int, viewModel : VehiclePickerViewModel, completion : @escaping (StepStatus) -> ())
    func description() -> String?
}

protocol VehiclePickerTableViewItem {
    func text() -> String
}


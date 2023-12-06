//
//  VehiclePickerCollectionViewDelegate.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

// swiftlint:disable:next class_delegate_protocol
protocol VehiclePickerCollectionViewDelegate {
    func getCollectionViewItems(viewModel: VehiclePickerViewModel) -> [VehiclePickerCollectionViewItem]
    func onCollectionViewItemSelected(pos: Int, viewModel: VehiclePickerViewModel, completion: (StepStatus) -> Void)
    func showLabel() -> Bool
}

protocol VehiclePickerCollectionViewItem {
    func title() -> String
    func image() -> UIImage?
}

// swiftlint:disable class_delegate_protocol
//
//  VehiclePickerTextDelegate.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 09/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

protocol VehiclePickerTextDelegate {
    func onLiteConfigSelected(viewModel: VehiclePickerViewModel)
    func onFullConfigSelected(viewModel: VehiclePickerViewModel)
    func categoryDescription() -> String
    func categoryImage() -> UIImage?
    func liteConfigId(isElectric: Bool) -> String?
}

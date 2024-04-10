//
//  VehiclePickerStepViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Amine Gahbiche on 13/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

import Foundation

struct VehiclePickerStepViewModel {
    let step: VehiclePickerStep
    let pickerViewModel: VehiclePickerViewModel

    func getTableViewItems() -> [VehiclePickerTableViewItem] {
        return step.getTableViewItems(viewModel: self.pickerViewModel)
    }

    func onTableViewItemSelected(pos: Int) {
        step.onTableViewItemSelected(pos: pos, viewModel: self.pickerViewModel)
    }

    func getCollectionViewItems() -> [VehiclePickerCollectionViewItem] {
        step.getCollectionViewItems(viewModel: self.pickerViewModel)
    }

    func onCollectionViewItemSelected(pos: Int, completion: (StepStatus) -> Void) {
        step.onCollectionViewItemSelected(pos: pos, viewModel: self.pickerViewModel, completion: completion)
    }

    func getStepDescription() -> String? {
        return step.description()
    }

    func showStepLabel() -> Bool {
        return step.showLabel()
    }

    func getTitle() -> String {
        return step.getTitle(viewModel: self.pickerViewModel)
    }
}

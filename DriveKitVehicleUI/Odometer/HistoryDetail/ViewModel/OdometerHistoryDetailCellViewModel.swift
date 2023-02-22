// swiftlint:disable all
//
//  OdometerHistoryDetailCellViewModel.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 26/10/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class OdometerHistoryDetailCellViewModel {
    private let type: HistoryCellType
    let isEditable: Bool
    let initialDistance: Double
    var newDistance: Double = 0

    init(initialDistance: Double?, type: HistoryCellType, isEditable: Bool) {
        self.initialDistance = initialDistance ?? 0
        self.type = type
        self.isEditable = isEditable
    }

    func showTextField() -> Bool {
        switch self.type {
            case .distance:
                return true
            case .date, .vehicle:
                return false
        }
    }

    func showLabel() -> Bool {
        switch self.type {
            case .distance:
                return false
            case .date, .vehicle:
                return true
        }
    }

    func getPlaceHolder() -> String {
        return self.type.placeholder
    }

    func getValue() -> String {
        return self.type.value
    }

    func getImage() -> UIImage? {
        switch self.type {
            case .vehicle:
                return self.type.image
            case .distance, .date:
                return self.type.image?.withRenderingMode(.alwaysTemplate)
        }
    }

    func getImageTintColor() -> UIColor? {
        switch self.type {
            case .vehicle:
                return nil
            case .distance, .date:
                return .black
        }
    }

    func getSelectionStyle() -> UITableViewCell.SelectionStyle {
        switch self.type {
            case .distance:
                return self.isEditable ? .default : .none
            case .date, .vehicle:
                return .none
        }
    }

    func hasCornerRadius() -> Bool {
        switch self.type {
            case .date, .distance:
                return false
            case .vehicle:
                return true
        }
    }
}

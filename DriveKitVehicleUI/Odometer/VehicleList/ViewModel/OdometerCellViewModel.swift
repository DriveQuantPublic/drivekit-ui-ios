//
//  OdometerCellViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 08/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule

struct OdometerCellViewModel {
    let odometer: DKVehicleOdometer?
    let lastUpdate: Date

    init(vehicleId: String?) {
        let vehicle: DKVehicle?
        if let vehicleId = vehicleId {
            vehicle = DriveKitVehicle.getVehicle(withId: vehicleId)
        } else {
            vehicle = nil
        }
        self.odometer = vehicle?.odometer
        self.lastUpdate = self.odometer?.updateDate ?? Date()
    }

    func getTitle(type: OdometerCellType) -> String {
        return type.titleKey.dkVehicleLocalized()
    }

    func getDescription(type: OdometerCellType) -> String {
        let localizedDescription = type.descriptionKey.dkVehicleLocalized()
        switch type {
            case .odometer:
                return getOdometerDescription(localizedDescription: localizedDescription)
            case .analyzedDistance:
                return getAnalyzedDistanceDescription(localizedDescription: localizedDescription)
            case .estimatedDistance:
                return getEstimatedDistanceDescription(localizedDescription: localizedDescription)
        }
    }

    func getDistance(type: OdometerCellType) -> String {
        switch type {
            case .odometer:
                return getOdometerDistance()
            case .analyzedDistance:
                return getAnalyzedDistance()
            case .estimatedDistance:
                return getEstimatedDistance()
        }
    }

    func getInfoContent(type: OdometerCellType) -> (title: String, message: String) {
        let alertTitleKey: String
        let alertMessageKey: String
        switch type {
            case .odometer:
                alertTitleKey = "dk_vehicle_odometer_info_vehicle_distance_title"
                alertMessageKey = "dk_vehicle_odometer_info_vehicle_distance_text"
            case .analyzedDistance:
                alertTitleKey = "dk_vehicle_odometer_info_analysed_distance_title"
                alertMessageKey = "dk_vehicle_odometer_info_analysed_distance_text"
            case .estimatedDistance:
                alertTitleKey = "dk_vehicle_odometer_info_estimated_distance_title"
                alertMessageKey = "dk_vehicle_odometer_info_estimated_distance_text"
        }
        return (alertTitleKey.dkVehicleLocalized(), alertMessageKey.dkVehicleLocalized())
    }

    private func getOdometerDescription(localizedDescription: String) -> String {
        return String(format: localizedDescription, self.lastUpdate.format(pattern: .standardDate))
    }

    private func getAnalyzedDistanceDescription(localizedDescription: String) -> String {
        return String(format: localizedDescription, self.odometer?.yearAnalyzedDistance.formatKilometerDistance(minDistanceToRemoveFractions: 0, forcedUnitSystem: .metric) ?? "0")
    }

    private func getEstimatedDistanceDescription(localizedDescription: String) -> String {
        let calendar = Calendar.current
        return String(format: localizedDescription, String(calendar.component(.year, from: self.lastUpdate)))
    }

    private func getOdometerDistance() -> String {
        return self.odometer?.distance.formatKilometerDistance(minDistanceToRemoveFractions: 0, forcedUnitSystem: .metric) ?? "0"
    }

    private func getAnalyzedDistance() -> String {
        return self.odometer?.analyzedDistance.formatKilometerDistance(minDistanceToRemoveFractions: 0, forcedUnitSystem: .metric) ?? "0"
    }

    private func getEstimatedDistance() -> String {
        return self.odometer?.estimatedYearDistance.formatKilometerDistance(minDistanceToRemoveFractions: 0, forcedUnitSystem: .metric) ?? "0"
    }
}

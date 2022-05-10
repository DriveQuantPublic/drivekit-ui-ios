//
//  TripSimulatorViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 20/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCommonUI
import DriveKitVehicleModule

class TripSimulatorViewModel {
    let items: [TripSimulatorItem] = [
        .trip(.shortTrip),
        .trip(.cityTrip),
        .trip(.mixedTrip),
        .trip(.suburbanTrip),
        .trip(.highwayTrip),
        .trip(.trainTrip),
        .trip(.boatTrip),
        .crashTrip(.unconfirmed0KmH),
        .crashTrip(.confirmed10KmH),
        .crashTrip(.confirmed20KmH),
        .crashTrip(.confirmed30KmH)
    ]
    private var selectedItemIndex: Int = 0

    func getDescriptionAttibutedText() -> NSAttributedString {
        return "trip_simulator_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
    }

    func getSelectedItem() -> TripSimulatorItem {
        if selectedItemIndex >= 0 && selectedItemIndex < items.count {
            return items[selectedItemIndex]
        } else {
            return items.first ?? .trip(.shortTrip)
        }
    }

    func getTripDescriptionAttibutedText() -> NSAttributedString {
        return getSelectedItem().getDescription().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
    }

    func getTripTitleText() -> String {
        return getSelectedItem().getTitle()
    }

    func selectItem(at index:Int) {
        guard index >= 0 && index < items.count else {
            return
        }
        selectedItemIndex = index
    }

    func isAutoStartEnabled() -> Bool {
        return DriveKitConfig.isTripAnalysisAutoStartEnabled()
    }

    func hasVehicleAutoStartMode() -> Bool {
        let vehicles = DriveKitVehicle.shared.vehiclesQuery().noFilter().query().execute()
        if vehicles.isEmpty {
            return false
        } else {
            let hasAutoStartMode = vehicles.contains { vehicle -> Bool in
                vehicle.detectionMode != .disabled
            }
            return hasAutoStartMode
        }
    }
}

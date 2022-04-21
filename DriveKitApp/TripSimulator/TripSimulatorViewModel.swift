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

class TripSimulatorViewModel {
    private let grayColor = UIColor(hex:0x9e9e9e)
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
    var selectedItemIndex: Int = 0

    func getDescriptionAttibutedText() -> NSAttributedString {
        return "trip_simulator_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(grayColor).build()
    }

    func getSelectedItem() -> TripSimulatorItem {
        if selectedItemIndex >= 0 && selectedItemIndex < items.count {
            return items[selectedItemIndex]
        } else {
            return items[0]
        }
    }

    func getTripDescriptionAttibutedText() -> NSAttributedString {
        return getSelectedItem().getDescription().dkAttributedString().font(dkFont: .primary, style: .smallText).color(grayColor).build()
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
}

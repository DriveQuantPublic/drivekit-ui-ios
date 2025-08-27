//
//  DriverPassengerModeViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 21/07/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import DriveKitCommonUI

class DriverPassengerModeViewModel {
    private let trip: DKTrip
    var selectedTransportationMode: TransportationMode?
    var passenger: Bool?
    var comment: String?

    init(trip: DKTrip) {
        self.trip = trip
        self.selectedTransportationMode = self.declaredTransportationMode()
        self.passenger = self.isPassenger
        self.comment = trip.declaredTransportationMode?.comment
    }
        
    private var isPassenger: Bool? {
        return trip.declaredTransportationMode?.passenger
    }
    
    var itinId: String {
        return trip.itinId
    }
    
    func declaredTransportationMode() -> TransportationMode? {
        return trip.declaredTransportationMode?.transportationMode
    }
    
    func declareTransportationMode(_ completionHandler: @escaping (DriveKitDriverDataModule.DKDeclaredTransportationModeStatus) -> Void) {
        guard let selectedTransportationMode, !self.itinId.isEmpty else {
            completionHandler(.failedToDeclareTransportationMode)
            return
        }
        DriveKitDriverData.shared.declareTransportationMode(
            itinId: self.itinId,
            mode: selectedTransportationMode,
            passenger: passenger ?? false,
            comment: comment,
            completionHandler: completionHandler
        )
    }

    func declareDriverPassengerMode(_ completionHandler: @escaping (DriveKitDriverDataModule.DKUpdateDriverPassengerModeStatus) -> Void) {
        guard let passenger, let selectedTransportationMode, selectedTransportationMode == .car, !self.itinId.isEmpty else {
            completionHandler(.failedToUpdateMode)
            return
        }
        DriveKitDriverData.shared.updateDriverPassengerMode(
            itinId: self.itinId,
            mode: passenger ? .passenger : .driver,
            comment: comment,
            completionHandler: completionHandler
        )
    }

    func getMessageAttributedText() -> NSAttributedString? {
        if trip.declaredTransportationMode == nil {
            return "dk_driverdata_ocupant_declaration_info".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.white).build()
        } else {
            return "dk_driverdata_ocupant_declaration_thanks".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.white).build()
        }
    }

    func getActionButtonTitle() -> String {
        if trip.declaredTransportationMode == nil {
            return DKCommonLocalizable.validate.text()
        } else {
            return DKCommonLocalizable.change.text()
        }
    }
}

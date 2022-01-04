//
//  ActivationHoursSlotCellViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 04/01/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitTripAnalysisModule

class ActivationHoursSlotCellViewModel {
    let slotType: SlotType
    var tripStatus: TripStatus

    init(slotType: SlotType, tripStatus: TripStatus) {
        self.slotType = slotType
        self.tripStatus = tripStatus
    }
}

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
    var tripStatus: TripStatus {
        didSet {
            if oldValue != self.tripStatus {
                self.delegate?.activationHoursSlotCellViewModel(self, didUpdateTripStatus: self.tripStatus, forType: self.slotType)
            }
        }
    }
    weak var delegate: ActivationHoursSlotCellViewModelDelegate?

    init(slotType: SlotType, tripStatus: TripStatus) {
        self.slotType = slotType
        self.tripStatus = tripStatus
    }
}

protocol ActivationHoursSlotCellViewModelDelegate: AnyObject {
    func activationHoursSlotCellViewModel(_ activationHoursSlotCellViewModel: ActivationHoursSlotCellViewModel, didUpdateTripStatus tripStatus: TripStatus, forType type: SlotType)
}

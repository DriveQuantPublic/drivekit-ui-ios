//
//  WorkingHoursSlotCellViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 04/01/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitTripAnalysisModule

class WorkingHoursSlotCellViewModel {
    let slotType: SlotType
    var tripStatus: TripStatus {
        didSet {
            if oldValue != self.tripStatus {
                self.delegate?.workingHoursSlotCellViewModel(self, didUpdateTripStatus: self.tripStatus, forType: self.slotType)
            }
        }
    }
    weak var delegate: WorkingHoursSlotCellViewModelDelegate?

    init(slotType: SlotType, tripStatus: TripStatus) {
        self.slotType = slotType
        self.tripStatus = tripStatus
    }
}

protocol WorkingHoursSlotCellViewModelDelegate: AnyObject {
    func workingHoursSlotCellViewModel(_ workingHoursSlotCellViewModel: WorkingHoursSlotCellViewModel, didUpdateTripStatus tripStatus: TripStatus, forType type: SlotType)
}

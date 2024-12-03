//
//  TripSharingViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 02/12/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

import DriveKitTripAnalysisModule

class TripSharingViewModel {
    var status: SharingLinkViewStatus = .loading
    var link: DKTripSharingLink?
    
    func updateStatus(completion: @escaping() -> Void) {
        guard DriveKitTripAnalysis.shared.tripSharing.isAvailable() == true else {
            self.status = .notAvailable
            completion()
            return
        }

        DriveKitTripAnalysis.shared.tripSharing.getLink(synchronizationType: .defaultSync) { status, data in
            self.link = data
            if let link = self.link {
                self.status = .active
            } else {
                self.status = .notActive
            }
            completion()
        }
    }
    
    func switchToPeriodSelection() {
        self.status = .selectingPeriod
    }
    
    func cancelPeriodSelection() {
        self.status = .notActive
    }
    
    func activateLinkSharing(period: SharingLinkPeriod, completion: @escaping() -> Void) {
        let durationInSeconds: Int
        let oneDayInSeconds = 86_400 // 60*60*24
        let oneWeekInSeconds = 604_800 // 60*60*24*7
        let oneMonthInSeconds = 2_592_000 // 60*60*24*30
        switch period {
            case .oneDay:
                durationInSeconds = oneDayInSeconds
            case .oneWeek:
                durationInSeconds = oneWeekInSeconds
            case .oneMonth:
                durationInSeconds = oneMonthInSeconds
        }
        DriveKitTripAnalysis.shared.tripSharing.createLink(durationInSeconds: durationInSeconds) { _, link in
            if let link = link {
                self.link = link
                self.status = .active
            } else {
                self.status = .notActive
            }
            completion()
        }
    }
        
    func revokeLink(completion: @escaping() -> Void) {
        DriveKitTripAnalysis.shared.tripSharing.revokeLink { _ in
            self.status = .notActive
            completion()
        }
    }
}

enum SharingLinkViewStatus {
    case loading
    case notAvailable
    case notActive
    case selectingPeriod
    case active
}

enum SharingLinkPeriod {
    case oneDay
    case oneWeek
    case oneMonth
}

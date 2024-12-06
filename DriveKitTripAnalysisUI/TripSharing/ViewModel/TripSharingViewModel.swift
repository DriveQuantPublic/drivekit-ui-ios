//
//  TripSharingViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 02/12/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

import DriveKitTripAnalysisModule
import DriveKitCommonUI

class TripSharingViewModel {
    var status: SharingLinkViewStatus = .loading
    var link: DKTripSharingLink?
    
    func updateStatus(completion: @escaping() -> Void) {
        guard DriveKitTripAnalysis.shared.tripSharing.isAvailable() == true else {
            self.status = .notAvailable
            completion()
            return
        }

        DriveKitTripAnalysis.shared.tripSharing.getLink(synchronizationType: .defaultSync) { _, data in
            self.link = data
            if self.link != nil {
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
        DriveKitTripAnalysis.shared.tripSharing.createLink(durationInSeconds: durationInSeconds) { status, link in
            if status == .activeLinkAlreadyExists {
                self.updateStatus {
                    completion()
                }
            } else if let link = link {
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
    
    func getAttributedText(for status: SharingLinkViewStatus) -> NSAttributedString {
        switch status {
            case .loading:
                return "".dkAttributedString().build()
            case .notAvailable:
                return "".dkAttributedString().build()
            case .notActive:
                return "\n%@\n\n%@\n\n%@"
                    .dkAttributedString()
                    .buildWithArgs(
                        "dk_location_sharing_select_description_1"
                            .dkTripAnalysisLocalized()
                            .dkAttributedString()
                            .font(dkFont: .primary, style: .normalText)
                            .color(.complementaryFontColor)
                            .build(),
                        "dk_location_sharing_inactive_description_2"
                            .dkTripAnalysisLocalized()
                            .dkAttributedString()
                            .font(dkFont: .primary, style: .normalText)
                            .color(.complementaryFontColor)
                            .build(),
                        "dk_location_sharing_inactive_description_3"
                            .dkTripAnalysisLocalized()
                            .dkAttributedString()
                            .font(dkFont: .primary, style: .normalText)
                            .color(.complementaryFontColor)
                            .build()
                    )
            case .selectingPeriod:
                return "\n%@\n\n%@"
                    .dkAttributedString()
                    .buildWithArgs(
                        "dk_location_sharing_select_description_1"
                            .dkTripAnalysisLocalized()
                            .dkAttributedString()
                            .font(dkFont: .primary, style: .normalText)
                            .color(.complementaryFontColor)
                            .build(),
                        "dk_location_sharing_select_description_2"
                            .dkTripAnalysisLocalized()
                            .dkAttributedString()
                            .font(dkFont: .primary, style: .normalText)
                            .color(.complementaryFontColor)
                            .build()
                    )
            case .active:
                let remaingTimeText = getRemaingTimeAttributedText()
                return "\n%@\n\n%@\n\n%@"
                    .dkAttributedString()
                    .buildWithArgs(
                        "dk_location_sharing_active_status"
                            .dkTripAnalysisLocalized()
                            .dkAttributedString()
                            .font(dkFont: .primary, style: .normalText)
                            .color(.complementaryFontColor)
                            .build(),
                        "dk_location_sharing_active_info"
                            .dkTripAnalysisLocalized()
                            .dkAttributedString()
                            .font(dkFont: .primary, style: .normalText)
                            .color(.complementaryFontColor)
                            .build(),
                        remaingTimeText
                    )
        }
    }
    
    func getRemaingTimeAttributedText() -> NSMutableAttributedString {
        guard let remaingTime = self.link?.endDate.timeIntervalSinceNow else {
            return "".dkAttributedString().build()
        }
        let remainingTimeInSeconds = Int(remaingTime)
        let oneDayInSeconds = 86_400 // 60*60*24
        let oneHourInSeconds = 3_600 // 60*60
        let oneMinuteInSeconds = 60
        
        let remaingDays = remainingTimeInSeconds / oneDayInSeconds
        if remaingDays > 1 {
            return "dk_location_sharing_active_info_days"
                .dkTripAnalysisLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .headLine2)
                .color(.complementaryFontColor)
                .buildWithArgs(
                    "\(remaingDays)"
                        .dkAttributedString()
                        .font(dkFont: .primary, style: .headLine2)
                        .color(.complementaryFontColor)
                        .build()
                )
        } else if remaingDays == 1 {
            return "dk_location_sharing_active_info_day".dkTripAnalysisLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .headLine2)
                .color(.complementaryFontColor)
                .build()
        } else {
            let remaingHours = remainingTimeInSeconds / oneHourInSeconds
            if remaingHours > 1 {
                return "dk_location_sharing_active_info_hours"
                    .dkTripAnalysisLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: .headLine2)
                    .color(.complementaryFontColor)
                    .buildWithArgs(
                        "\(remaingHours)"
                            .dkAttributedString()
                            .font(dkFont: .primary, style: .headLine2)
                            .color(.complementaryFontColor)
                            .build()
                    )
            } else if remaingHours == 1 {
                return "dk_location_sharing_active_info_hour"
                    .dkTripAnalysisLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: .headLine2)
                    .color(.complementaryFontColor)
                    .build()
            } else {
                let remaingMinutes = remainingTimeInSeconds / oneMinuteInSeconds
                if remaingMinutes > 1 {
                    return "dk_location_sharing_active_info_minutes"
                        .dkTripAnalysisLocalized()
                        .dkAttributedString()
                        .font(dkFont: .primary, style: .headLine2)
                        .color(.complementaryFontColor)
                        .buildWithArgs(
                            "\(remaingMinutes)"
                                .dkAttributedString()
                                .font(dkFont: .primary, style: .headLine2)
                                .color(.complementaryFontColor)
                                .build()
                        )
                } else /*if remaingMinutes == 1*/ {
                    return "dk_location_sharing_active_info_minute"
                        .dkTripAnalysisLocalized()
                        .dkAttributedString()
                        .font(dkFont: .primary, style: .headLine2)
                        .color(.complementaryFontColor)
                        .build()
                }
            }
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
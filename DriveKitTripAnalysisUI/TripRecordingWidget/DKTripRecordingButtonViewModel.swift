//
//  DKTripRecordingButtonViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Frédéric Ruaudel on 11/05/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import CoreLocation
import DriveKitTripAnalysisModule
import Foundation

public class DKTripRecordingButtonViewModel {
    enum RecordingState {
        case stopped
        case recording(startingDate: Date, distance: Double, duration: Double)
        
        var startingDate: Date? {
            switch self {
            case .stopped:
                return nil
            case let .recording(startingDate, _, _):
                return startingDate
            }
        }
    }
    
    var state: RecordingState = .stopped
    public var viewModelDidUpdate: (() -> Void)?
    
    public init() {
        DriveKitTripAnalysis.shared.addTripListener(self)
    }
    
    deinit {
        DriveKitTripAnalysis.shared.removeTripListener(self)
    }
    
    public var title: NSAttributedString {
        switch state {
        case .stopped:
            return "dk_tripwidget_start_title".dkTripAnalysisLocalized()
                .uppercased()
                .dkAttributedString()
                .font(dkFont: .primary, style: .headLine1)
                .color(.white)
                .build()
        case let .recording(startingDate, _, _):
            let dateText = startingDate.format(pattern: .hourMinuteLetter)
                .dkAttributedString()
                .font(dkFont: .primary, style: .headLine2)
                .color(.white)
                .build()
            return "dk_tripwidget_record_title".dkTripAnalysisLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .headLine2)
                .color(.white)
                .buildWithArgs(dateText)
        }
    }
    
    public var hasSubtitles: Bool {
        switch state {
        case .stopped:
            return false
        case .recording:
            return true
        }
    }
    
    public var distanceSubtitle: NSAttributedString? {
        switch state {
        case .stopped:
            return nil
        case let .recording(_, distance, _):
            let never = 1_000_000.0
            let distanceValueText = distance.formatKilometerDistance(
                appendingUnit: true,
                minDistanceToRemoveFractions: never
            )
                .dkAttributedString()
                .font(dkFont: .primary, style: .normalText)
                .color(.white)
                .build()
            let distanceText = "dk_tripwidget_record_subtitle_distance"
                .dkTripAnalysisLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .normalText)
                .color(.white)
                .build()
            
            return "%@ %@".dkAttributedString()
                .font(dkFont: .primary, style: .normalText)
                .color(.white)
                .buildWithArgs(distanceText, distanceValueText)
        }
    }
    
    public var durationSubtitle: NSAttributedString? {
        switch state {
        case .stopped:
            return nil
        case let .recording(_, _, duration):
            let durationValueText = duration.formatSecondDuration(maxUnit: .hour)
                .dkAttributedString()
                .font(dkFont: .primary, style: .normalText)
                .color(.white)
                .build()
            let durationText = "dk_tripwidget_record_subtitle_duration"
                .dkTripAnalysisLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .normalText)
                .color(.white)
                .build()
            
            return "%@ %@".dkAttributedString()
                .font(dkFont: .primary, style: .normalText)
                .color(.white)
                .buildWithArgs(durationText, durationValueText)
        }
    }
    
    public var iconImage: UIImage {
        switch state {
        case .stopped:
            return UIImage(
                named: "dk_trip_analysis_play",
                in: .tripAnalysisUIBundle,
                compatibleWith: nil
            )!
        case .recording:
            return UIImage(
                named: "dk_trip_analysis_stop",
                in: .tripAnalysisUIBundle,
                compatibleWith: nil
            )!
        }
    }
}

extension DKTripRecordingButtonViewModel: TripListener {
    public func tripStarted(startMode: DriveKitTripAnalysisModule.StartMode) {
        state = .recording(
            startingDate: Date(),
            distance: 0,
            duration: 0
        )
        self.viewModelDidUpdate?()
    }
    
    public func tripPoint(tripPoint: DriveKitTripAnalysisModule.TripPoint) {
        state = .recording(
            startingDate: state.startingDate ?? Date(),
            distance: tripPoint.distance,
            duration: tripPoint.duration
        )
        self.viewModelDidUpdate?()
    }
    
    public func tripFinished(post: DriveKitTripAnalysisModule.PostGeneric, response: DriveKitTripAnalysisModule.PostGenericResponse) {
        state = .stopped
        self.viewModelDidUpdate?()
    }
    
    public func tripCancelled(cancelTrip: DriveKitTripAnalysisModule.CancelTrip) {
        state = .stopped
        self.viewModelDidUpdate?()
    }
    
    public func tripSavedForRepost() {}
    
    public func beaconDetected() {}
    
    public func significantLocationChangeDetected(location: CLLocation) {}
    
    public func sdkStateChanged(state: DriveKitTripAnalysisModule.State) {}
    
    public func potentialTripStart(startMode: DriveKitTripAnalysisModule.StartMode) {}
    
    public func crashDetected(crashInfo: DriveKitTripAnalysisModule.DKCrashInfo) {}
    
    public func crashFeedbackSent(
        crashInfo: DriveKitTripAnalysisModule.DKCrashInfo,
        feedbackType: DriveKitTripAnalysisModule.DKCrashFeedbackType,
        severity: DriveKitTripAnalysisModule.DKCrashFeedbackSeverity
    ) {}
}

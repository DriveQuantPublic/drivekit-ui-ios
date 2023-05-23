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
        
        var duration: Double? {
            switch self {
            case .stopped:
                return nil
            case let .recording(_, _, duration):
                return duration
            }
        }
    }
    
    var state: RecordingState = .stopped {
        didSet {
            switch (oldValue, state) {
            case (.recording, .stopped):
                stopTimer()
            case (.stopped, .recording):
                startTimer()
            default:
                break
            }
            self.viewModelDidUpdate?()
        }
    }
    public var canShowTripStopConfirmationDialog: Bool {
        guard case .recording = state else { return false }
        return true
    }
    public var viewModelDidUpdate: (() -> Void)?
    public private(set) var tripRecordingUserMode: DKTripRecordingUserMode
    private var timerCancelId: Timer?
    
    public init(
        tripRecordingUserMode: DKTripRecordingUserMode
    ) {
        self.tripRecordingUserMode = tripRecordingUserMode
        DriveKitTripAnalysis.shared.addTripListener(self)
    }
    
    deinit {
        DriveKitTripAnalysis.shared.removeTripListener(self)
    }
    
    public var isHidden: Bool {
        switch (tripRecordingUserMode, state) {
        case (.startStop, _):
            return false
        case (.stopOnly, .stopped):
            return true
        case (.stopOnly, .recording):
            return false
        case (.none, _):
            return true
        }
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
            return distance.formatMeterDistanceInKm(
                appendingUnit: true,
                minDistanceToRemoveFractions: never
            )
                .dkAttributedString()
                .font(dkFont: .primary, style: .normalText)
                .color(.white)
                .build()
        }
    }
    
    public var durationSubtitle: NSAttributedString? {
        switch state {
        case .stopped:
            return nil
        case let .recording(_, _, duration):
            return duration.formatSecondDurationWithColons()
                .dkAttributedString()
                .font(dkFont: .primary, style: .normalText)
                .color(.white)
                .build()
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
    
    public func buttonTapped(completion: (Bool) -> Void) {
        var shouldShowConfirmationDialog: Bool
        switch state {
        case .stopped:
            state = .recording(startingDate: Date(), distance: 0, duration: 0)
            DriveKitTripAnalysis.shared.startTrip()
            shouldShowConfirmationDialog = false
        case .recording:
            shouldShowConfirmationDialog = true
        }
        completion(shouldShowConfirmationDialog)
    }
    
    private func startTimer() {
        guard self.timerCancelId == nil else { return }
        self.timerCancelId = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            guard case let .recording(startingDate, distance, duration) = self.state else {
                assertionFailure("We should not have a timer tick outside of recording state")
                return
            }

            self.state = .recording(
                startingDate: startingDate,
                distance: distance,
                duration: duration + 1
            )
        })
    }
    
    private func stopTimer() {
        self.timerCancelId?.invalidate()
        self.timerCancelId = nil
    }
}

extension DKTripRecordingButtonViewModel: TripListener {
    public func tripStarted(startMode: DriveKitTripAnalysisModule.StartMode) {}
    
    public func tripPoint(tripPoint: DriveKitTripAnalysisModule.TripPoint) {
        DispatchQueue.dispatchOnMainThread { [weak self] in
            guard let self else { return }
            self.state = .recording(
                startingDate: state.startingDate ?? Date(
                    timeIntervalSinceNow: -tripPoint.duration
                ),
                distance: tripPoint.distance,
                duration: state.duration ?? tripPoint.duration
            )
        }
    }
    
    public func tripFinished(post: DriveKitTripAnalysisModule.PostGeneric, response: DriveKitTripAnalysisModule.PostGenericResponse) { }
    
    public func tripCancelled(cancelTrip: DriveKitTripAnalysisModule.CancelTrip) {
        DispatchQueue.dispatchOnMainThread { [weak self] in
            guard let self else { return }
            self.state = .stopped
        }
    }
    
    public func tripSavedForRepost() {}
    
    public func beaconDetected() {}
    
    public func significantLocationChangeDetected(location: CLLocation) {}
    
    public func sdkStateChanged(state: DriveKitTripAnalysisModule.State) {
        DispatchQueue.dispatchOnMainThread { [weak self] in
            guard let self else { return }
            switch state {
            case .inactive:
                self.state = .stopped
            case .starting:
                self.state = .recording(
                    startingDate: self.state.startingDate ?? Date(),
                    distance: 0,
                    duration: 0
                )
            case .sending:
                self.state = .stopped
            case .running, .stopping:
                break
            @unknown default:
                break
            }
        }
    }
    
    public func potentialTripStart(startMode: DriveKitTripAnalysisModule.StartMode) {}
    
    public func crashDetected(crashInfo: DriveKitTripAnalysisModule.DKCrashInfo) {}
    
    public func crashFeedbackSent(
        crashInfo: DriveKitTripAnalysisModule.DKCrashInfo,
        feedbackType: DriveKitTripAnalysisModule.DKCrashFeedbackType,
        severity: DriveKitTripAnalysisModule.DKCrashFeedbackSeverity
    ) {}
}

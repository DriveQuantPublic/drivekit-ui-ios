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
import UIKit

class DKTripRecordingButtonViewModel {
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
        
        var distance: Double? {
            switch self {
            case .stopped:
                return nil
            case let .recording(_, distance, _):
                return distance
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
    var canShowTripStopConfirmationDialog: Bool {
        switch (tripRecordingUserMode, state) {
        case (.startStop, .recording),
             (.stopOnly, .recording):
            return true
        case (.startStop, _),
             (.startOnly, _),
             (.stopOnly, _),
             (.none, _):
            return false
        }
    }
    var viewModelDidUpdate: (() -> Void)?
    private(set) var tripRecordingUserMode: DKTripRecordingUserMode
    private var timer: Timer?
    
    static var isTripConfirmed: Bool {
        DriveKitTripAnalysis.shared.getCurrentTripInfo()?.startMode == .manual ||
        [.running, .stopping].contains(DriveKitTripAnalysis.shared.getRecorderState())
    }
    
    init(
        tripRecordingUserMode: DKTripRecordingUserMode
    ) {
        self.tripRecordingUserMode = tripRecordingUserMode
        if Self.isTripConfirmed {
            if let lastTripPoint = DriveKitTripAnalysis.shared.getLastTripPointOfCurrentTrip() {
                self.updateState(with: lastTripPoint)
            } else if let startingDate = DriveKitTripAnalysis.shared.getCurrentTripInfo()?.date {
                self.updateState(
                    with: startingDate
                )
            }
        }
        DriveKitTripAnalysis.shared.addTripListener(self)
    }
    
    deinit {
        DriveKitTripAnalysis.shared.removeTripListener(self)
        stopTimer()
    }
    
    var isHidden: Bool {
        switch (tripRecordingUserMode, state) {
        case (.startStop, _):
            return false
        case (.startOnly, _):
            return false
        case (.stopOnly, .stopped):
            return true
        case (.stopOnly, .recording):
            return false
        case (.none, _):
            return true
        }
    }
    
    var isEnabled: Bool {
        switch (tripRecordingUserMode, state) {
        case (.startStop, _):
            return true
        case (.startOnly, .stopped):
            return true
        case (.startOnly, .recording):
            return false
        case (.stopOnly, _):
            return true
        case (.none, _):
            return false
        }
    }
    
    var title: NSAttributedString {
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
    
    var hasSubtitles: Bool {
        switch state {
        case .stopped:
            return false
        case .recording:
            return true
        }
    }
    
    var distanceSubtitle: NSAttributedString? {
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
                .font(dkFont: .roboto, style: .normalText)
                .color(.white)
                .build()
        }
    }
    
    var durationSubtitle: NSAttributedString? {
        switch state {
        case .stopped:
            return nil
        case let .recording(_, _, duration):
            return duration.formatSecondDurationWithColons()
                .dkAttributedString()
                .font(dkFont: .roboto, style: .normalText)
                .color(.white)
                .build()
        }
    }
    
    var iconImage: UIImage {
        let iconName: String
        switch (tripRecordingUserMode, state) {
        case (_, .stopped):
            iconName = "dk_trip_analysis_play"
        case (.startOnly, .recording):
            iconName = "dk_trip_analysis_record"
        case (_, .recording):
            iconName = "dk_trip_analysis_stop"
        }
        return UIImage(
            named: iconName,
            in: .tripAnalysisUIBundle,
            compatibleWith: nil
        )!
    }
    
    func toggleRecordingState() -> Bool {
        var shouldShowConfirmationDialog: Bool
        switch state {
        case .stopped:
            self.updateState(with: Date())
            DriveKitTripAnalysis.shared.cancelTemporaryDeactivation()
            DriveKitTripAnalysis.shared.startTrip()
            shouldShowConfirmationDialog = false
        case .recording:
            shouldShowConfirmationDialog = true
        }
        
        return shouldShowConfirmationDialog
    }
    
    private func startTimer() {
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            guard case let .recording(startingDate, distance, _) = self.state else {
                assertionFailure("We should not have a timer tick outside of recording state")
                return
            }

            self.updateState(
                with: startingDate,
                distance: distance
            )
        })
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func updateState(with tripPoint: TripPoint) {
        self.state = .recording(
            startingDate: state.startingDate ?? Date(
                timeIntervalSinceNow: -tripPoint.duration
            ),
            distance: tripPoint.distance,
            duration: state.duration ?? tripPoint.duration
        )
    }
    
    private func updateState(with startingDate: Date, distance: Double = 0) {
        self.state = .recording(
            startingDate: startingDate,
            distance: distance,
            duration: -startingDate.timeIntervalSinceNow
        )
    }
}

extension DKTripRecordingButtonViewModel: TripListener {
    func tripStarted(startMode: DriveKitTripAnalysisModule.StartMode) {}
    
    func tripPoint(tripPoint: DriveKitTripAnalysisModule.TripPoint) {
        DispatchQueue.dispatchOnMainThread { [weak self] in
            guard let self else { return }
            self.updateState(with: tripPoint)
        }
    }
    
    func tripCancelled(cancelTrip: DriveKitTripAnalysisModule.CancelTrip) {
        DispatchQueue.dispatchOnMainThread { [weak self] in
            guard let self else { return }
            self.state = .stopped
        }
    }
    
    func tripSavedForRepost() {}
    
    func sdkStateChanged(state: DriveKitTripAnalysisModule.State) {
        DispatchQueue.dispatchOnMainThread { [weak self] in
            guard let self else { return }
            switch state {
            case .inactive:
                self.state = .stopped
            case .starting:
                // We don't update the button in this state
                // because it can be a false positive (ghost trip,
                // geozone exit by foot, etc.)
                break
            case .sending:
                self.state = .stopped
            case .running, .stopping:
                self.updateState(
                    with: self.state.startingDate ?? Date(),
                    distance: self.state.distance ?? 0.0
                )
            @unknown default:
                break
            }
        }
    }
}

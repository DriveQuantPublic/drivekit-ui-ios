//
//  TripSimulatorDetailViewModel .swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 22/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import CoreLocation
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import DriveKitTripSimulatorModule

protocol TripSimulatorDetailViewModelDelegate: NSObject {
    func updateNeeded(updatedValue: Double?, timestamp: Double?)
}

class TripSimulatorDetailViewModel {
    weak var delegate: TripSimulatorDetailViewModelDelegate?
    private var simulatedItem: TripSimulatorItem
    private var currentDuration: Double = 0
    private var timeWhenEnteredStoppingState: Date?
    private var stoppingTimer: Timer? = nil
    private(set) var isSimulating: Bool = true
    private var velocityBuffer: CircularBuffer<Double> = CircularBuffer(size: 30)

    init(simulatedItem: TripSimulatorItem) {
        self.simulatedItem = simulatedItem
        self.startSimulation()
        TripListenerManager.shared.addTripListener(self)
    }

    deinit {
        TripListenerManager.shared.removeTripListener(self)
    }

    func stopSimulation() {
        DriveKitTripSimulator.shared.stop()
        isSimulating = false
    }

    func startSimulation() {
        currentDuration = 0
        timeWhenEnteredStoppingState = nil
        stoppingTimer?.invalidate()
        stoppingTimer = nil

        switch simulatedItem {
        case .trip(let presetTrip):
            DriveKitTripSimulator.shared.start(presetTrip, delegate: self)
        case .crashTrip(let presetCrashConfiguration):
            DriveKitTripSimulator.shared.startCrashTrip(presetCrashConfiguration, delegate: self)
        }
        isSimulating = true
    }

    func getTotalDurationText() -> String {
        let duration: Double = simulatedItem.getSimulationDuration()
        return formatDuration(duration: duration)
    }

    func getStateText() -> String {
        let state = DriveKitTripAnalysis.shared.getRecorderState()
        switch state {
        case .inactive:
            return "INACTIVE"
        case .starting:
            return "STARTING"
        case .running:
            return "RUNNING"
        case .stopping:
            return "STOPPING"
        case .sending:
            return "SENDING"
        }
    }

    func getSpentDurationText() -> String {
        if isSimulating {
            return formatDuration(duration: currentDuration)
        } else {
            return "-"
        }
    }

    func getSpeedText() -> String {
        if let lastSpeed = velocityBuffer.last, isSimulating {
            return lastSpeed.formatSpeedMean()
        } else {
            return "-"
        }
    }

    func shouldDisplayStoppingMessage() -> Bool {
        return DriveKitTripAnalysis.shared.getRecorderState() == .stopping
    }

    func getRemainingTimeToStopText() -> String {
        guard let timeWhenEnteredStoppingState = timeWhenEnteredStoppingState else {
            return ""
        }
        let timeOut: Int = DriveKitTripAnalysis.shared.stopTimeOut
        let remainingDuration = Double(timeOut) - Date().timeIntervalSince(timeWhenEnteredStoppingState)
        return formatDuration(duration: remainingDuration)
    }

    func getTripTitle() -> String {
        return simulatedItem.getTitle()
    }

    func getTripDescription() -> String {
        return simulatedItem.getDescription()
    }

    func formatDuration(duration: Double) -> String {
        let durationInt = Int(duration)
        let seconds: Int = durationInt % 60
        let minutes: Int = (durationInt - seconds) / 60
        return String(format: "%02d:%02d", arguments: [minutes, seconds])
    }

    func updateStoppingTime(state: State) {
        if state == .stopping {
          if timeWhenEnteredStoppingState == nil {
              timeWhenEnteredStoppingState = Date()
              self.stoppingTimer?.invalidate()
              self.stoppingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateNeeded), userInfo: nil, repeats: true)
          }
        } else {
            self.stoppingTimer?.invalidate()
            self.stoppingTimer = nil
            timeWhenEnteredStoppingState = nil
        }
    }

    @objc func updateNeeded() {
        DispatchQueue.dispatchOnMainThread { [weak self] in
            if let self = self {
                self.delegate?.updateNeeded(updatedValue: nil, timestamp: nil)
            }
        }
    }
}


extension TripSimulatorDetailViewModel: DKTripSimulatorDelegate {
    func locationSent(location: CLLocation, durationSinceStart: Double) {
        self.currentDuration = durationSinceStart + 1
        let speedKmH = location.speed * 3600 / 1000
        self.velocityBuffer.append(speedKmH)

        let state = DriveKitTripAnalysis.shared.getRecorderState()
        updateStoppingTime(state: state)

        DispatchQueue.dispatchOnMainThread { [weak self] in
            if let self = self, let velocity = self.velocityBuffer.last {
                self.delegate?.updateNeeded(updatedValue: velocity, timestamp: self.currentDuration)
            }
        }
    }
}

extension TripSimulatorDetailViewModel: TripListener {
    func tripStarted(startMode: StartMode) {
    }
    
    func tripPoint(tripPoint: TripPoint) {
    }
    
    func tripFinished(post: PostGeneric, response: PostGenericResponse) {
        if currentDuration >= simulatedItem.getSimulationDuration() {
            isSimulating = false
            updateNeeded()
        }
    }
    
    func tripCancelled(cancelTrip: CancelTrip) {
    }
    
    func tripSavedForRepost() {
    }
    
    func beaconDetected() {
    }
    
    func significantLocationChangeDetected(location: CLLocation) {
    }
    
    func sdkStateChanged(state: State) {
        updateStoppingTime(state: state)
        updateNeeded()
    }
    
    func potentialTripStart(startMode: StartMode) {
    }
    
    func crashDetected(crashInfo: DKCrashInfo) {
    }
    
    func crashFeedbackSent(crashInfo: DKCrashInfo, feedbackType: DKCrashFeedbackType, severity: DKCrashFeedbackSeverity) {
    }
}

//
//  TripSimulatorDetailViewModel.swift
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

protocol TripSimulatorDetailViewModelDelegate: AnyObject {
    func updateNeeded(updatedValue: Double?, timestamp: Double?)
}

class TripSimulatorDetailViewModel {
    weak var delegate: TripSimulatorDetailViewModelDelegate?
    private var simulatedItem: TripSimulatorItem
    private var currentDuration: Double = 0
    private var timeWhenEnteredStoppingState: Date?
    private var stoppingTimer: Timer?
    private(set) var isSimulating: Bool = true
    private var currentSpeed: Double?

    init(simulatedItem: TripSimulatorItem) {
        self.simulatedItem = simulatedItem
        self.startSimulation()
        DriveKitTripAnalysis.shared.addTripListener(self)
    }

    deinit {
        DriveKitTripAnalysis.shared.removeTripListener(self)
    }

    func stopSimulation() {
        DriveKitTripSimulator.shared.stop()
        isSimulating = false
    }

    func startSimulation() {
        currentDuration = 0
        currentSpeed = nil
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
            @unknown default:
                return "?"
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
        if let lastSpeed = currentSpeed, isSimulating {
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
        let secondsInMinute: Int = 60
        let durationInt = Int(duration)
        let seconds: Int = durationInt % secondsInMinute
        let minutes: Int = (durationInt - seconds) / secondsInMinute
        return String(format: "%02d:%02d", arguments: [minutes, seconds])
    }

    func updateStoppingTime(state: State) {
        if state == .stopping {
          if timeWhenEnteredStoppingState == nil {
              timeWhenEnteredStoppingState = Date()
              self.stoppingTimer?.invalidate()
              self.stoppingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateNeeded), userInfo: nil, repeats: true)
          }
            if currentDuration >= simulatedItem.getSimulationDuration() {
                currentSpeed = nil
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
        let conversionRatio: Double = 3.6 // 3_600 / 1_000
        let speedKmH = location.speed * conversionRatio
        self.currentSpeed = speedKmH

        let state = DriveKitTripAnalysis.shared.getRecorderState()
        updateStoppingTime(state: state)

        DispatchQueue.dispatchOnMainThread { [weak self] in
            if let self = self {
                self.delegate?.updateNeeded(updatedValue: speedKmH, timestamp: self.currentDuration)
            }
        }
    }
}

extension TripSimulatorDetailViewModel: TripListener {
    func tripRecordingFinished(state: any DKTripRecordingFinishedState) {
        tripSimulationDidEnd()
    }

    func sdkStateChanged(state: State) {
        updateStoppingTime(state: state)
        updateNeeded()
    }

    private func tripSimulationDidEnd() {
        if currentDuration >= simulatedItem.getSimulationDuration() {
            stopSimulation()
            updateNeeded()
        }
    }
}

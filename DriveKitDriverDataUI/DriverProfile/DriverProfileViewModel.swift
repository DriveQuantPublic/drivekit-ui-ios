//
//  DriverProfileViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 26/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import Foundation

class DriverProfileViewModel {
    let configuredPeriods: [DKPeriod] = [.week, .month, .year]
    weak var delegate: DriverProfileViewModelDelegate?
    private var currentDrivenDistances: [DKPeriod: Double]
    private var driverProfile: DKDriverProfile?
    var driverProfileFeaturePagingViewModel: DriverProfileFeaturePagingViewModel
    var driverDistanceEstimationPagingViewModel: DriverDistanceEstimationPagingViewModel
    var driverCommonTripPagingViewModel: DriverCommonTripPagingViewModel
    private(set) var updating: Bool = false
    
    init() {
        self.currentDrivenDistances = [:]
        self.driverProfileFeaturePagingViewModel = .init()
        self.driverDistanceEstimationPagingViewModel = .init()
        self.driverCommonTripPagingViewModel = .init()
        
        DriveKitDriverData.shared.getDriverProfile(
            type: .cache
        ) { [weak self] status, driverProfile in
            guard let self else { return }
            if status == .success, let driverProfile {
                self.driverProfile = driverProfile
                
                DriveKitDriverData.shared.getDriverTimelines(
                    periods: self.configuredPeriods,
                    type: .cache
                ) { [weak self] status, timelines in
                    guard let self else { return }
                    if status == .cacheDataOnly, let timelines {
                        self.currentDrivenDistances = timelines.reduce(into: [:]) { resultSoFar, timeline in
                            resultSoFar[timeline.period] = self.getDistance(for: timeline.allContext.last, period: timeline.period)
                        }
                    }
                    self.update()
                }
            }
        }

        updateData()
    }
    
    var shouldHideDrivingConditions: Bool {
        false
    }
    
    var drivingConditionsViewModel: DrivingConditionsViewModel {
        let viewModel = DrivingConditionsViewModel()
        return viewModel
    }
    
    func updateData() {
        self.updating = true
        self.delegate?.willUpdateData()
        DriveKitDriverData.shared.getDriverProfile(
            type: .defaultSync
        ) { [weak self] status, driverProfile in
            guard let self else { return }
            if status == .success, let driverProfile {
                self.driverProfile = driverProfile
                
                DriveKitDriverData.shared.getDriverTimelines(
                    periods: self.configuredPeriods,
                    type: .defaultSync
                ) { [weak self] status, timelines in
                    guard let self else { return }
                    if status != .noTimelineYet, let timelines {
                        self.currentDrivenDistances = timelines.reduce(into: [:]) { resultSoFar, timeline in
                            resultSoFar[timeline.period] = self.getDistance(for: timeline.allContext.last, period: timeline.period)
                        }
                    }
                    
                    self.updating = false
                    self.update()
                    self.delegate?.didUpdateData()
                }
            } else {
                self.updating = false
                self.update()
                self.delegate?.didUpdateData()
            }
        }
    }
    
    private func update() {
        guard let driverProfile = self.driverProfile else {
            configureWithNoData()
            return
        }
        
        driverProfileFeaturePagingViewModel.configure(with: driverProfile)
        driverDistanceEstimationPagingViewModel.configure(with: driverProfile, and: currentDrivenDistances)
        driverCommonTripPagingViewModel.configure(with: driverProfile.commonTripByType)
    }
    
    private func configureWithNoData() {
        driverProfileFeaturePagingViewModel.configureWithNoData()
        driverDistanceEstimationPagingViewModel.configureWithNoData()
        driverCommonTripPagingViewModel.configureWithNoData()
    }

    private func getDistance(for timeline: DKDriverTimeline.DKAllContextItem?, period: DKPeriod) -> Double {
        guard let timeline = timeline else {
            return 0
        }
        let periodDate: Date
        switch period {
            case .week:
                periodDate = Date().startOfWeek ?? Date()
            case .month:
                periodDate = Date().beginning(relativeTo: .month) ?? Date()
            case .year:
                periodDate = Date().beginning(relativeTo: .year) ?? Date()
        }
        if let date = timeline.date.dateByRemovingTime(), date == periodDate {
            return timeline.distance
        }
        return 0
    }
}

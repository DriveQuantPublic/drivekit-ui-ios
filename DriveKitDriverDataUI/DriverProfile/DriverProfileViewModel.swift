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
        
        DriveKitDriverData.shared.getDriverTimelines(
            periods: self.configuredPeriods,
            type: .cache
        ) { [weak self] status, timelines in
            guard let self else { return }
            if status == .cacheDataOnly, let timelines {
                self.currentDrivenDistances = timelines.reduce(into: [:]) { resultSoFar, timeline in
                    resultSoFar[timeline.period] = timeline.allContext.last?.distance ?? 0.0
                }
            }
            
            DriveKitDriverData.shared.getDriverProfile(
                type: .cache
            ) { [weak self] status, driverProfile in
                guard let self else { return }
                if status == .success, let driverProfile {
                    self.driverProfile = driverProfile
                }
                self.update()
            }
        }
        updateData()
    }
    
    var drivingConditionsViewModel: DrivingConditionsViewModel {
        let viewModel = DrivingConditionsViewModel()
        return viewModel
    }
    
    func updateData() {
        self.updating = true
        self.delegate?.willUpdateData()
        DriveKitDriverData.shared.getDriverTimelines(
            periods: configuredPeriods,
            type: .defaultSync
        ) { [weak self] status, timelines in
            guard let self else { return }
            if status != .noTimelineYet, let timelines {
                self.currentDrivenDistances = timelines.reduce(into: [:]) { resultSoFar, timeline in
                    resultSoFar[timeline.period] = timeline.allContext.last?.distance ?? 0.0
                }
                self.update()
            }
            
            DriveKitDriverData.shared.getDriverProfile(
                type: .defaultSync
            ) { [weak self] status, driverProfile in
                guard let self else { return }
                if status == .success, let driverProfile {
                    self.driverProfile = driverProfile
                }
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
        
        #warning("TODO: configure each sub-VM for data state")
    }
    
    private func configureWithNoData() {
        #warning("TODO: configure each sub-VM for empty state")
    }
}

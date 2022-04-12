//
//  SynchroServicesManager.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import DriveKitVehicleModule
import DriveKitDriverDataModule
import DriveKitDriverAchievementModule
import DriveKitChallengeModule

enum DKService {
    case userInfo
    case vehicle
    case workingHours
    case trips
    case badge
    case challenge
}

enum SyncStatus {
    case success
    case failed
    case skipped
}

class SynchroServicesManager {

    static func syncModule(_ service: DKService, completion: ((SyncStatus) -> ())? = nil) {
        switch service {
            case .badge:
                syncBadges(completion: completion)
            case .challenge:
                syncChallenges(completion: completion)
            case .vehicle:
                syncVehicles(completion: completion)
            case .workingHours:
                syncWorkingHours(completion: completion)
            case .userInfo:
                syncUserInfo(completion: completion)
            case .trips:
                syncTrips(completion: completion)
        }
    }

    static func syncModules(_ services: [DKService],  previousResults: [SyncStatus] = [], stepCompletion: ((SyncStatus, _ remainingServices: [DKService]) -> ())? = nil, completion: (([SyncStatus]) -> ())? = nil) {
        guard let service = services.first else {
            return
        }
        var results: [SyncStatus] = previousResults
        if services.count == 1 {
            syncModule(service) { status in
                results.append(status)
                DispatchQueue.dispatchOnMainThread {
                    stepCompletion?(status, [])
                    completion?(results)
                }
            }
        } else if services.count > 1 {
            var remainingServices = services
            remainingServices.removeFirst()
            syncModule(service) { status in
                results.append(status)
                DispatchQueue.dispatchOnMainThread {
                    stepCompletion?(status, remainingServices)
                }
                syncModules(remainingServices, previousResults: results, stepCompletion: stepCompletion, completion: completion)
            }
        }
    }

    private static func syncBadges(completion: ((SyncStatus) -> ())?) {
        DriveKitDriverAchievement.shared.getBadges(completionHandler: {status, _, _ in
            completion?(status == .noError ? .success : .failed)
        })
    }

    private static func syncChallenges(completion: ((SyncStatus) -> ())?) {
        DriveKitChallenge.shared.getChallenges(type: .defaultSync) { status, _ in
            completion?(status == .success ? .success : .failed)
        }
    }

    private static func syncVehicles(completion: ((SyncStatus) -> ())?) {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc{ status, _ in
            completion?(status == .noError ? .success : .failed)
        }
    }

    private static func syncWorkingHours(completion: ((SyncStatus) -> ())?) {
        DriveKitTripAnalysis.shared.getWorkingHours(type: .defaultSync) { status, workingHours in
            completion?(status == .success ? .success : .failed)
        }
    }

    private static func syncUserInfo(completion: ((SyncStatus) -> ())?) {
        DriveKit.shared.getUserInfo(synchronizationType: .defaultSync) { status, _ in
            completion?(status == .success ? .success : .failed)
        }
    }

    private static func syncTrips(completion: ((SyncStatus) -> ())?) {
        DriveKitDriverData.shared.getTripsOrderByDateAsc(type: .defaultSync) { status, _ in
            completion?(status == .noError ? .success : .failed)
        }
    }
}
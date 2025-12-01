//
//  FindMyVehicleViewModelDelegate.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 06/11/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//

protocol FindMyVehicleViewModelDelegate: AnyObject {
    func userLocationUpdateFinished()
    func addressGeocodingFinished()
    func directionsRequestFinished()
}

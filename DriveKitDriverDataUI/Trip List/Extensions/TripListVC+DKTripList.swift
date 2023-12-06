//
//  TripListVC+DKTripList.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 13/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitCommonUI

extension TripListVC: DKTripList {
    public func didSelectTrip(itinId: String) {
        self.showTripDetail(itinId: itinId)
    }
    public func getTripData() -> TripData {
        return DriveKitDriverDataUI.shared.tripData
    }
    public func getTripsList() -> [DKTripsByDate] {
        return self.viewModel.filteredTrips
    }
    public func getCustomHeader() -> DKHeader? {
        return DriveKitDriverDataUI.shared.customHeaders
    }
    public func getHeaderDay() -> HeaderDay {
        return DriveKitDriverDataUI.shared.headerDay
    }
    public func canPullToRefresh() -> Bool {
        return true
    }
    public func didPullToRefresh() {
        self.viewModel.fetchTrips()
        DriveKit.shared.modules.tripAnalysis?.checkTripToRepost()
    }
}

extension TripListVC {
    private func showTripDetail(itinId: String) {
        if let navigationController = self.navigationController {
            let tripDetail = TripDetailVC(itinId: itinId, showAdvice: false, listConfiguration: self.viewModel.listConfiguration)
            navigationController.pushViewController(tripDetail, animated: true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": itinId])
        }
    }
}

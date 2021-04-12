//
//  TripTableViewDelegate.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 03/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverDataModule


extension TripListVC {
    private func showTripDetail(itinId : String) {
        if let navigationController = self.navigationController {
            let tripDetail = TripDetailVC(itinId: itinId, showAdvice: false, listConfiguration: self.viewModel.listConfiguration)
            navigationController.pushViewController(tripDetail, animated: true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": itinId])
        }
    }
}

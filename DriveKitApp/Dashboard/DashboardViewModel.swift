//
//  DashboardViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitDriverDataUI
import DriveKitPermissionsUtilsUI
import DriveKitTripAnalysisModule

class DashboardViewModel {
    private(set) var bannerViewModels: [InfoBannerViewModel] = []
    weak var delegate: DashboardViewModelDelegate?

    private static let alreadyOpenedDriverPassengerModeKey = "DriveKitApp.alreadyOpenedDriverPassengerMode"
    static var alreadyOpenedDriverPassengerMode: Bool {
        get {
            DriveKitCoreUserDefaults.getPrimitiveType(key: alreadyOpenedDriverPassengerModeKey) ?? false
        }
        set {
            DriveKitCoreUserDefaults.setPrimitiveType(
                key: alreadyOpenedDriverPassengerModeKey,
                value: newValue)
        }
    }

    init() {
        updateBanners()
        NotificationCenter.default.addObserver(self, selector: #selector(updateBanners), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBanners), name: .sensorStateChangedNotification, object: nil)
    }

    func getSynthesisCardsView() -> UIView {
        return DriveKitDriverDataUI.shared.getLastTripsSynthesisCardsView()
    }

    func getLastTripsView(parentViewController: UIViewController) -> UIView {
        return DriveKitDriverDataUI.shared.getLastTripsView(parentViewController: parentViewController)
    }

    @objc func updateBanners() {
        var newBannerViewModels: [InfoBannerViewModel] = []
        for banner in InfoBannerType.allCases where banner.shouldDisplay {
            newBannerViewModels.append(InfoBannerViewModel(type: banner))
        }
        self.bannerViewModels = newBannerViewModels
        self.delegate?.bannersDidUpdate()
    }
}

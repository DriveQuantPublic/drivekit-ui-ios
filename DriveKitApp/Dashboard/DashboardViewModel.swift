//
//  DashboardViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverDataUI
import DriveKitPermissionsUtilsUI
import DriveKitTripAnalysisModule

class DashboardViewModel {
    private(set) var bannerViewModels: [InfoBannerViewModel] = []
    weak var delegate: DashboardViewModelDelegate?

    init() {
        TripListenerManager.shared.addSdkStateChangeListener(self)
        updateBanners()
        NotificationCenter.default.addObserver(self, selector: #selector(updateBanners), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBanners), name: .sensorStateChangedNotification, object: nil)
    }

    deinit {
        TripListenerManager.shared.removeSdkStateChangeListener(self)
    }

    func getStartStopTripButtonTitle() -> String {
        if DriveKitTripAnalysis.shared.isTripRunning() {
            return "stop_trip".keyLocalized()
        } else {
            return "start_trip".keyLocalized()
        }
    }

    func getSynthesisCardsView() -> UIView {
        return DriveKitDriverDataUI.shared.getLastTripsSynthesisCardsView()
    }

    func getLastTripsView(parentViewController: UIViewController) -> UIView {
        return DriveKitDriverDataUI.shared.getLastTripsView(parentViewController: parentViewController)
    }

    func startStopTrip() {
        if DriveKitTripAnalysis.shared.isTripRunning() {
            DriveKitTripAnalysis.shared.stopTrip()
        } else {
            DriveKitTripAnalysis.shared.startTrip()
        }
    }

    @objc func updateBanners() {
        var newBannerViewModels: [InfoBannerViewModel] = []
        for banner in InfoBannerType.allCases {
            if banner.shouldDisplay {
                newBannerViewModels.append(InfoBannerViewModel(type: banner))
            }
        }
        self.bannerViewModels = newBannerViewModels
        self.delegate?.bannersDidUpdate()
    }
}

extension DashboardViewModel: SdkStateChangeListener {
    func sdkStateChanged(state: State) {
        DispatchQueue.dispatchOnMainThread {
            self.delegate?.updateStartStopButton()
        }
    }
}

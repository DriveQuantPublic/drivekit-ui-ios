//
//  DiagnosisViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 16/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class DiagnosisViewController : DKUIViewController {

    @IBOutlet private weak var globalStatus: GlobalStateView!
    @IBOutlet private weak var locationStatus: SensorStateView!
    @IBOutlet private weak var notificationStatus: SensorStateView!
    @IBOutlet private weak var connectionStatus: SensorStateView!
    @IBOutlet private weak var activityStatus: SensorStateView!
    @IBOutlet private weak var bluetoothStatus: SensorStateView!

    private var viewModel: DiagnosisViewModel

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = DiagnosisViewModel()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.view = self
        self.update()
    }

}

extension DiagnosisViewController : DiagnosisView {

    func update() {
        self.globalStatus.viewModel = self.viewModel.globalStatusViewModel
        self.locationStatus.viewModel = self.viewModel.locationStatusViewModel
        self.notificationStatus.viewModel = self.viewModel.notificationStatusViewModel
        self.connectionStatus.viewModel = self.viewModel.connectionStatusViewModel
        self.activityStatus.viewModel = self.viewModel.activityStatusViewModel
        self.bluetoothStatus.viewModel = self.viewModel.bluetoothStatusViewModel
    }

}

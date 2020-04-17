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

    @IBOutlet private weak var globalStatus: SensorStateView!
    @IBOutlet private weak var locationStatus: SensorStateView!
    @IBOutlet private weak var notificationStatus: SensorStateView!
    @IBOutlet private weak var connectionStatus: SensorStateView!
    @IBOutlet private weak var activityStatus: SensorStateView!
    @IBOutlet private weak var blutoothStatus: SensorStateView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//
//  LocationPermissionViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import CoreLocation

import DriveKitCommonUI

class LocationPermissionViewController : PermissionViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var settingsContainer1: UIView!
    @IBOutlet weak var settingsDescription1: UILabel!
    @IBOutlet weak var settingsContainer2: UIView!
    @IBOutlet weak var settingsDescription2: UILabel!
    @IBOutlet weak var settingsContainer3: UIView!
    @IBOutlet weak var settingsDescription3: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkState()
    }


    @IBAction func openSettings(_ sender: UIButton) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl)
    }


    private func updateView() {
        self.titleLabel.attributedText = "dk_perm_utils_permissions_location_title".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.mainFontColor).build()

        self.actionButton.setAttributedTitle("dk_perm_utils_permissions_location_button_ios".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
        self.actionButton.backgroundColor = DKUIColors.secondaryColor.color

        if #available(iOS 13.0, *) {
            updateViewIOS13()
        } else {
            updateViewPreIOS13()
        }
    }

    private func updateViewIOS13() {
        self.descriptionLabel.attributedText = "dk_perm_utils_permissions_location_ios13".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        self.settingsContainer1.isHidden = false
        self.settingsDescription1.attributedText = "dk_perm_utils_permissions_phone_settings_location_step1".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        self.settingsContainer2.isHidden = false
        self.settingsDescription2.attributedText = "dk_perm_utils_permissions_phone_settings_location_step2".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        self.settingsContainer3.isHidden = false
        self.settingsDescription3.attributedText = "dk_perm_utils_permissions_phone_settings_location_step3".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }

    private func updateViewPreIOS13() {
        self.descriptionLabel.attributedText = "dk_perm_utils_permissions_location_pre_ios13_ko".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()

        self.settingsContainer1.isHidden = true
        self.settingsContainer2.isHidden = true
        self.settingsContainer3.isHidden = true
    }


    @objc private func checkState() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.location) {
            case .notDetermined:
                askAuthorization()
                break
            case .valid:
                next()
                break
            default:
                break
        }
    }

    @objc private func askAuthorization() {
        if DKDiagnosisHelper.shared.getPermissionStatus(.location) == .notDetermined {
            if #available(iOS 13.0, *) {
                self.locationManager.requestWhenInUseAuthorization()
            } else {
                self.locationManager.requestAlwaysAuthorization()
            }
            self.locationManager.delegate = self
        }
    }


    @objc private func appDidBecomeActive() {
        checkState()
    }

}

extension LocationPermissionViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkState()
    }

}

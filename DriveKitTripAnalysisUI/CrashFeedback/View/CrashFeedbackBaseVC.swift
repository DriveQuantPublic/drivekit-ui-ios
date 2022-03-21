//
//  CrashFeedbackBaseVC.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 09/03/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

class CrashFeedbackBaseVC: UIViewController {
    let greenColor = UIColor(hex: 0x77E2B0)
    let redColor = UIColor(hex: 0xEA676B)
    let yellowColor = UIColor(hex: 0xEBD37F)
    func dismiss() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func makeCrashAssistanceCall() {
        if let number = DriveKitTripAnalysisUI.shared.roadsideAssistanceNumber {
            let url = URL(string: "tel://\(number)")!
            UIApplication.shared.open(url)
        }
    }
}

class ButtonWithRightIcon: UIButton {
    let verticalPadding: CGFloat = 2
    let horizonatalPadding: CGFloat = 8
    let imageWidth: CGFloat = 40
    override func layoutSubviews() {
        super.layoutSubviews()
        guard imageView != nil else {
            return
        }
        imageEdgeInsets = UIEdgeInsets(top: verticalPadding, left: (bounds.width - imageWidth - horizonatalPadding), bottom: verticalPadding, right: horizonatalPadding)
        titleEdgeInsets = UIEdgeInsets(top: verticalPadding, left: horizonatalPadding * 2 - imageWidth, bottom: verticalPadding, right: horizonatalPadding )
    }
}

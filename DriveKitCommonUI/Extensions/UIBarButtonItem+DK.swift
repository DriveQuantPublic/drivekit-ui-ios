//
//  UIBarButtonItem+DK.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 01/09/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    func applyStyle(color: UIColor = DKUIColors.navBarElementColor.color, applyToTitle: Bool = false) {
        self.tintColor = color
        if applyToTitle {
            self.setTitleTextAttributes([.foregroundColor: color], for: .normal)
        }
        if #available(iOS 26.0, *) {
            self.hidesSharedBackground = true
        }
    }
}

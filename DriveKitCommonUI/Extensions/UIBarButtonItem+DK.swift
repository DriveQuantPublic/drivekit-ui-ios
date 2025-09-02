//
//  UIBarButtonItem+DK.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 01/09/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    func applyDKStyle() {
        self.tintColor = DKUIColors.navBarElementColor.color
        if #available(iOS 26.0, *) {
            self.hidesSharedBackground = true
        }
    }
}

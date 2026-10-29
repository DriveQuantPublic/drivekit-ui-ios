//
//  UINavigationController+DK.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 26/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public extension UINavigationController {
    func configure() {
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: DKStyles.bigtext.style.applyTo(font: .secondary),
            .foregroundColor: DKUIColors.navBarElementColor.color
        ]
        let buttonTextAttributes: [NSAttributedString.Key: Any] = [
            .font: DKStyles.normalText.style.applyTo(font: .secondary),
            .foregroundColor: DKUIColors.navBarElementColor.color
        ]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundEffect = nil
        appearance.backgroundColor = DKUIColors.primaryColor.color
        appearance.titleTextAttributes = titleTextAttributes
        appearance.buttonAppearance.normal.titleTextAttributes = buttonTextAttributes
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }

    func configure(from navigationController: UINavigationController) {
        self.navigationBar.isTranslucent = navigationController.navigationBar.isTranslucent
        self.navigationBar.standardAppearance = navigationController.navigationBar.standardAppearance
        self.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.scrollEdgeAppearance
        self.navigationBar.barTintColor = navigationController.navigationBar.barTintColor
        self.navigationBar.tintColor = navigationController.navigationBar.tintColor
    }
}

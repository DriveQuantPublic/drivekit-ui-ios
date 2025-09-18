//
//  UIApplication+DK.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 09/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

extension UIApplication {
    public var visibleViewController: UIViewController? {
        let window = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .last { $0.isKeyWindow }
        guard let rootViewController = window?.rootViewController else {
                  return nil
        }
        return getVisibleViewController(rootViewController)
    }

    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        return rootViewController
    }
}

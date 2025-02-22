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
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = window.rootViewController else {
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

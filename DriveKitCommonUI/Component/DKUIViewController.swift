//
//  DKUIViewController.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 26/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

open class DKUIViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBackButton()
        self.view.backgroundColor = DKUIColors.backgroundView.color
        if let navigationController = self.navigationController {
            navigationController.navigationBar.barTintColor = DKUIColors.primaryColor.color
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DriveKitUI.shared.trackScreen(self)
    }

    open func configureBackButton(selector: Selector = #selector(onBack)) {
        DKUIViewController.configureBackButton(viewController: self, selector: selector)
    }

    public static func configureBackButton(viewController: UIViewController, selector: Selector) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let backImage = DKImages.back.image
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(viewController, action: selector, for: .touchUpInside)
        backButton.tintColor = DKUIColors.navBarElementColor.color
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc open func onBack(sender: UIBarButtonItem) {
        if let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

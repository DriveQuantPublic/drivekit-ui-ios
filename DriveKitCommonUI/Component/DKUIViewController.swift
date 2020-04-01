//
//  DKUIViewController.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 26/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

open class DKUIViewController : UIViewController{
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBackButton()
        self.view.backgroundColor = DKUIColors.backgroundView.color
    }
    
    open func configureBackButton(selector: Selector = #selector(onBack)) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        let backImage = DKImages.back.image
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: selector, for: .touchUpInside)
        backButton.tintColor = DKUIColors.fontColorOnPrimaryColor.color
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc open func onBack(sender: UIBarButtonItem) {
        if let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

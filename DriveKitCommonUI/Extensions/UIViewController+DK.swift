//
//  UIViewController+DK.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 01/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func showLoader() {
        let darkView = UIView(frame: UIScreen.main.bounds)
        darkView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        let loaderView = UIActivityIndicatorView(style: .whiteLarge)
        loaderView.center = darkView.center
        darkView.tag = 1000
        darkView.addSubview(loaderView)
        view.addSubview(darkView)
        loaderView.startAnimating()
    }
    
    func hideLoader() {
        if let loaderView = view.viewWithTag(1000) {
            loaderView.removeFromSuperview()
        }
    }
    
    func showAlertMessage(title: String?, message: String?, back: Bool, cancel: Bool, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: {action in
            if back {
                self.dismiss(animated: false, completion: completion)
            }
        })
        if cancel {
            let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}


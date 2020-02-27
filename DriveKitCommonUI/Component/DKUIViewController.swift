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
        self.view.backgroundColor = DriveKitUI.shared.colors.backgroundViewColor
    }
    
    open func showLoader() {
        let alert = UIAlertController(title: nil, message: DKCommonLocalizable.loading.text(), preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: false, completion: nil)
    }
    
    open func hideLoader() {
        dismiss(animated: true, completion: nil)
    }
    
}

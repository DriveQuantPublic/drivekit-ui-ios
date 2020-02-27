//
//  DKUIViewController.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 26/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

open class DKUIViewController : UIViewController{
    
    private var overlay: UIView? = nil
    private var loader: UIActivityIndicatorView = UIActivityIndicatorView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DriveKitUI.shared.colors.backgroundViewColor
    }
    
    open func showLoader() {
        let darkView = UIView(frame: UIScreen.main.bounds)
        darkView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        let loaderView = UIActivityIndicatorView(style: .whiteLarge)
        loaderView.center = darkView.center
        darkView.tag = 1000
        darkView.addSubview(loaderView)
        view.addSubview(darkView)
        loaderView.startAnimating()
    }
    
    open func hideLoader() {
        if let loaderView = view.viewWithTag(1000) {
            loaderView.removeFromSuperview()
        }
    }
}

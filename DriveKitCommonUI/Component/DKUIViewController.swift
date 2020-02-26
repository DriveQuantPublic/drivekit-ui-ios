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
    
}

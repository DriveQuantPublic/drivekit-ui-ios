//
//  UserIdViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class UserIdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.title = "authentication_header".keyLocalized()
        self.navigationItem.hidesBackButton = true
    }

}

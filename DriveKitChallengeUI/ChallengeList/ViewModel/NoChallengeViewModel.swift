//
//  NoChallengeViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

struct NoChallengeViewModel {
    let text: String
    let image: UIImage?
    let backgroundColor: UIColor
    let textColor: UIColor

    init(text: String,
         image: UIImage?,
         backgroundColor: UIColor = .white,
         textColor: UIColor = .black ) {

        self.text = text
        self.image = image
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
}

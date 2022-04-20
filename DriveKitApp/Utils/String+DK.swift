//
//  String+DK.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 08/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

extension String {
    func keyLocalized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

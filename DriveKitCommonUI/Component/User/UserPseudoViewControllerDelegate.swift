//
//  UserPseudoViewControllerDelegate.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 02/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public protocol UserPseudoViewControllerDelegate: AnyObject {
    func pseudoDidUpdate(success: Bool)
}

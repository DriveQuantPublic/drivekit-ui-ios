// swiftlint:disable no_magic_numbers
//
//  UIView+DK.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

extension UIView {
    static func reducePageControl(in view: UIView) {
        for subview in view.subviews {
            if subview is UIPageControl {
                subview.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                subview.addConstraint(subview.heightAnchor.constraint(equalToConstant: 17))
                break
            } else {
                reducePageControl(in: subview)
            }
        }
    }
}

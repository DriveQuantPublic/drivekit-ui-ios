//
//  UIView+DK.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 02/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public extension UIView {
    func embedSubview(_ subview: UIView, margins: UIEdgeInsets = UIEdgeInsets.zero) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        let metrics = [
            "topMargin": margins.top,
            "bottomMargin": margins.bottom,
            "leftMargin": margins.left,
            "rightMargin": margins.right
        ]
        let bindings = ["subview": subview]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(topMargin)-[subview]-(bottomMargin@999)-|",
                                                      options: [],
                                                      metrics: metrics,
                                                      views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(leftMargin)-[subview]-(rightMargin)-|",
                                                      options: [],
                                                      metrics: metrics,
                                                      views: bindings))
    }

    func removeSubviews() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }

    func applyCardStyle() {
        roundCorners()
        addShadow()
    }

    func roundCorners(clipping clipsToBounds: Bool = false) {
        self.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.layer.masksToBounds = false
        self.clipsToBounds = clipsToBounds
    }

    func addShadow() {
        self.layer.shadowColor = DKUIConstants.UIStyle.shadowColor
        self.layer.shadowOpacity = DKUIConstants.UIStyle.shadowOpacity
        self.layer.shadowOffset = DKUIConstants.UIStyle.shadowOffset
        self.layer.shadowRadius = DKUIConstants.UIStyle.shadowRadius
        self.layer.masksToBounds = false
    }
}

public extension UIStackView {
    func removeAllSubviews() {
        let subviews = self.arrangedSubviews
        if !subviews.isEmpty {
            for view in subviews {
                self.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
    }
}

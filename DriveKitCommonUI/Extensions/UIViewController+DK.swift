// swiftlint:disable no_magic_numbers
//
//  UIViewController+DK.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 01/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public extension UIViewController {
    private static let loaderViewTag = 1_000
    private static let loaderTextViewTag = loaderViewTag + 1

    func showLoader() {
        showLoader(message: nil)
    }

    func showLoader(message: String?) {
        if let loaderView = self.view.viewWithTag(UIViewController.loaderViewTag) {
            if let label = loaderView.viewWithTag(UIViewController.loaderTextViewTag) as? UILabel {
                updateLoaderMessage(message: message, label: label, loaderView: loaderView)
            }
        } else {
            let loaderView = UIView(frame: self.view.bounds)
            loaderView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            loaderView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
            loaderView.tag = UIViewController.loaderViewTag

            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
            activityIndicator.center = loaderView.center
            activityIndicator.startAnimating()
            loaderView.addSubview(activityIndicator)

            let margin: CGFloat = 40
            let label = UILabel(frame: CGRect(x: margin, y: activityIndicator.frame.maxY, width: self.view.bounds.size.width - 2 * margin, height: 60))
            label.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
            label.numberOfLines = 0
            label.textColor = .white
            label.textAlignment = .center
            label.font = DKStyles.normalText.withSizeDelta(-2).applyTo(font: .primary)
            label.tag = UIViewController.loaderTextViewTag
            loaderView.addSubview(label)
            updateLoaderMessage(message: message, label: label, loaderView: loaderView)

            self.view.addSubview(loaderView)
        }
    }

    private func updateLoaderMessage(message: String?, label: UILabel, loaderView: UIView) {
        label.text = message
        var labelFrame = label.frame
        labelFrame.origin.y = loaderView.center.y + 26
        let maxHeight = loaderView.bounds.size.height - labelFrame.origin.y - 10
        let size = label.sizeThatFits(CGSize(width: labelFrame.size.width, height: maxHeight))
        let height = min(size.height, maxHeight)
        labelFrame.size = CGSize(width: labelFrame.size.width, height: height)
        label.frame = labelFrame
    }

    func hideLoader() {
        if let loaderView = self.view.viewWithTag(UIViewController.loaderViewTag) {
            loaderView.removeFromSuperview()
        }
    }

    func showAlertMessage(title: String?, message: String?, back: Bool, cancel: Bool, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: { _ in
            if back {
                self.dismiss(animated: false, completion: completion)
            } else if let completion = completion {
                completion()
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

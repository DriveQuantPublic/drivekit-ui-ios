//
//  SynthesisCardTest.swift
//  DriveKitApp
//
//  Created by David Bauduin on 13/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDriverDataUI

struct SynthesisCardTest {

    private init() {}

    static func getSynthesisCardViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white

        let cardsView = DriveKitDriverDataUI.shared.getLastTripsSynthesisCardsView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        addShadow(to: cardsView)
        viewController.view.addSubview(cardsView)

        let margin = CGFloat(10)
        viewController.view.addConstraints([
            cardsView.heightAnchor.constraint(equalToConstant: 220),
            cardsView.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: margin),
            cardsView.leftAnchor.constraint(equalTo: viewController.view.leftAnchor, constant: margin),
            cardsView.rightAnchor.constraint(equalTo: viewController.view.rightAnchor, constant: -margin)
        ])

        let customCardView = DriverDataSynthesisCardsUI.getSynthesisCardView(CustomSynthesisCard())
        customCardView.translatesAutoresizingMaskIntoConstraints = false
        addShadow(to: customCardView)
        viewController.view.addSubview(customCardView)
        viewController.view.addConstraints([
            customCardView.heightAnchor.constraint(equalToConstant: 200),
            customCardView.topAnchor.constraint(equalTo: cardsView.bottomAnchor, constant: margin),
            customCardView.leftAnchor.constraint(equalTo: viewController.view.leftAnchor, constant: margin),
            customCardView.rightAnchor.constraint(equalTo: viewController.view.rightAnchor, constant: -margin)
        ])
        return viewController
    }

    private static func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }

}

private struct CustomSynthesisCard: DKSynthesisCard {
    func getTitle() -> String {
        "Custom synthesis card"
    }

    func getExplanationContent() -> String? {
        return nil
    }

    func getGaugeConfiguration() -> DKGaugeConfiguration {
        return CustomGaugeConfiguration()
    }

    func getTopSynthesisCardInfo() -> DKSynthesisCardInfo {
        return CustomSynthesisCardInfo(icon: DKImages.calendar.image, text: "Top")
    }

    func getMiddleSynthesisCardInfo() -> DKSynthesisCardInfo {
        return CustomSynthesisCardInfo(icon: nil, text: "")
    }

    func getBottomSynthesisCardInfo() -> DKSynthesisCardInfo {
        return CustomSynthesisCardInfo(icon: DKImages.clock.image, text: "Bottom")
    }

    func getBottomText() -> NSAttributedString? {
        return nil
    }
}

private struct CustomGaugeConfiguration: DKGaugeConfiguration {
    func getColor() -> UIColor {
        return .blue
    }

    func getGaugeType() -> DKGaugeType {
        return .close
    }

    func getProgress() -> Double {
        return 0.33
    }

    func getTitle() -> String {
        return "33%"
    }
}

private struct CustomSynthesisCardInfo: DKSynthesisCardInfo {
    fileprivate let icon: UIImage?
    fileprivate let text: String

    func getIcon() -> UIImage? {
        self.icon
    }

    func getText() -> NSAttributedString {
        self.text.dkAttributedString().build()
    }
}

//
//  LastTripsViewTest.swift
//  DriveKitApp
//
//  Created by David Bauduin on 20/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDriverDataUI

class LastTripsViewTest : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        let lastTripsView = DriveKitDriverDataUI.shared.getLastTripsView(delegate: self)
        lastTripsView.translatesAutoresizingMaskIntoConstraints = false
        addShadow(to: lastTripsView)
        self.view.addSubview(lastTripsView)

        let margin = CGFloat(10)
        self.view.addConstraints([
            lastTripsView.heightAnchor.constraint(equalToConstant: 100),
            lastTripsView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: margin),
            lastTripsView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            lastTripsView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin)
        ])
    }

    private func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }

}

extension LastTripsViewTest : DKLastTripsWidgetDelegate {
    func didSelectTrip(_ trip: DKTripListItem) {
        //TODO
        print("======== didSelectTrip")
    }

    func openTripList() {
        //TODO
        print("======== openTripList")
    }
}

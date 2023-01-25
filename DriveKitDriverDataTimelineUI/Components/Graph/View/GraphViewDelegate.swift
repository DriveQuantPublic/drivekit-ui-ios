// swiftlint:disable all
//
//  GraphViewDelegate.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

protocol GraphViewDelegate: AnyObject {
    func graphDidSelectPoint(_ point: GraphPoint)
}

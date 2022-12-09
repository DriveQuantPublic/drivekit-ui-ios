//
//  Graph.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 25/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

typealias GraphPoint = (x: Double, y: Double, data: PointData?)

struct PointData {
    let date: Date
    let interpolatedPoint: Bool
}

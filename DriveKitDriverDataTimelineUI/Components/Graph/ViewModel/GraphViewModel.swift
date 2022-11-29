//
//  GraphViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

protocol GraphViewModel {
    var graphViewModelDidUpdate: (() -> ())? { get set }
    var type: GraphType { get }
    var points: [GraphPoint?] { get }
    var selectedIndex: Int? { get }
    var xAxisConfig: GraphAxisConfig? { get }
    var yAxisConfig: GraphAxisConfig? { get }
}

// swiftlint:disable all
//
//  GraphAxisConfig.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

struct GraphAxisConfig {
    let min: Double
    let max: Double
    let labels: LabelType
    
    enum LabelType {
        case rawValues(labelCount: Int)
        case customLabels([String])
        
        var count: Int {
            switch self {
            case let .rawValues(labelCount):
                return labelCount
            case let .customLabels(labels):
                return labels.count
            }
        }
        
        var titles: [String]? {
            switch self {
            case .rawValues:
                return nil
            case let .customLabels(titles):
                return titles
            }
        }
    }
}

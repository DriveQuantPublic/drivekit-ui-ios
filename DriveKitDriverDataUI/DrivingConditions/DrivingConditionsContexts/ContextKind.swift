//
//  ContextKind.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation

enum ContextKind: Int, CaseIterable {
    case tripDistance = 0, week, road, weather, dayNight
    
    var previous: ContextKind? {
        let index = self.rawValue
        return .init(rawValue: index - 1)
    }
    
    var next: ContextKind? {
        let index = self.rawValue
        return .init(rawValue: index + 1)
    }
}

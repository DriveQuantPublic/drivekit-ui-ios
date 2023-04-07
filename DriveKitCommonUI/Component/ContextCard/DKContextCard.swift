//
//  DKContextCard.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 06/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

public protocol DKContextCard {
    func getItems() -> [any DKContextItem]
    func getTitle() -> String
    func getEmptyDataDescription() -> String
    func getContextPercent(_ context: some DKContextItem) -> Double
}

public protocol DKContextItem {
    func getColor() -> UIColor
    func getTitle() -> String
    func getSubtitle() -> String?
}

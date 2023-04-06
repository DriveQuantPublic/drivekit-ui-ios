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
}

public protocol DKContextItem {
    func getColor() -> UIColor
    func getPercent() -> Double
    func getTitle() -> String
    func getSubtitle() -> String?
}

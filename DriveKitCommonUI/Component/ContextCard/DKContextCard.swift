//
//  DKContextCard.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 06/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

public protocol DKContextCard {
    var items: [any DKContextItem] { get }
    var title: String { get }
    func getContextPercent(_ context: some DKContextItem) -> Double
    func contextCard(_ updateCompletionHandler: (() -> Void)?)
}

public protocol DKContextItem {
    var color: UIColor { get }
    var title: String { get }
    var subtitle: String? { get }
}

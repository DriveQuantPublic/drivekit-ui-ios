//
//  DrivingConditionsContextCard.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 18/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import Foundation
import UIKit

enum UnitKind {
    case trip
    case kilometer
}

class DrivingConditionsContextCard {
    var contextItems: [DrivingConditionsContextItem]
    var viewModelDidUpdate: (() -> Void)?
    var title: String
    var totalItemsValue: Double
    
    init() {
        self.contextItems = []
        self.viewModelDidUpdate = nil
        self.title = ""
        self.totalItemsValue = 0
    }
}

extension DrivingConditionsContextCard: DKContextCard {
    var items: [DriveKitCommonUI.DKContextItem] {
        self.contextItems
    }
    
    func getContextPercent(_ context: some DriveKitCommonUI.DKContextItem) -> Double {
        guard let contextItem = context as? DrivingConditionsContextItem else {
            return 0
        }
        return contextItem.itemValue / totalItemsValue
    }
    
    func contextCardDidUpdate(_ completionHandler: (() -> Void)?) {
        viewModelDidUpdate = completionHandler
    }
    
    func title(
        between context1: (String, DrivingConditionsContextItem?),
        and context2: (String, DrivingConditionsContextItem?),
        l10nTagIfSame: String
    ) -> String {
        guard let context1Item = context1.1 else {
            return "dk_driverdata_drivingconditions_main_\(context2.0)".dkDriverDataLocalized()
        }
        
        let context1Percent = self.getContextPercent(context1Item)
        let minPercent = 0.45
        let maxPercent = 0.55
        if context1Percent < minPercent {
            return "dk_driverdata_drivingconditions_main_\(context2.0)".dkDriverDataLocalized()
        } else if context1Percent > maxPercent {
            return "dk_driverdata_drivingconditions_main_\(context1.0)".dkDriverDataLocalized()
        } else {
            return "dk_driverdata_drivingconditions_all_\(l10nTagIfSame)".dkDriverDataLocalized()
        }
    }
    
    func titleForItemWithMaxValue<Key: Hashable>(amongst items: [Key: DrivingConditionsContextItem], titleForKey: (Key) -> String) -> String {
        let (_, key) = items.reduce(
            into: (maxValue: 0.0, key: Key?.none)
        ) { maxValueAndKeySoFar, dictItem in
            if dictItem.value.itemValue >= maxValueAndKeySoFar.maxValue {
                maxValueAndKeySoFar.maxValue = dictItem.value.itemValue
                maxValueAndKeySoFar.key = dictItem.key
            }
        }
        
        return key.map(titleForKey) ?? ""
    }
}

struct DrivingConditionsContextItem: DKContextItem {
    var title: String
    var itemValue: Double
    var totalItemsValue: Double
    var baseColor: DKContextCardColor
    var unitKind: UnitKind = .kilometer

    var color: UIColor {
        baseColor.color.tinted(usingHueOf: DKUIColors.primaryColor.color)
    }
    
    var subtitle: String? {
        
        switch unitKind {
        case .trip:
            let unitText: String
            if itemValue > 1 {
                unitText = DKCommonLocalizable.tripPlural.text()
            } else {
                unitText = DKCommonLocalizable.tripSingular.text()
            }
            return Int(self.itemValue).formatWithThousandSeparator() + " " + unitText
        case .kilometer:
            return self.itemValue.formatKilometerDistance(
                minDistanceToRemoveFractions: DrivingConditionsConstants.minDistanceToRemoveFractions(forTotalDistance: totalItemsValue)
            )
        }
    }
}

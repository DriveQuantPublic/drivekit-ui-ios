//
//  FilterViewModel.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 30/09/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

public protocol DKFilterItem {
    func getImage() -> UIImage?
    func getName() -> String
    func getId() -> Any?
}

public class DKFilterViewModel {
    
    var items : [DKFilterItem]
    var currentItem : DKFilterItem
    let showPicker : Bool
    
    init(items: [DKFilterItem], currentItem : DKFilterItem, showPicker: Bool) {
        self.items = items
        self.currentItem = currentItem
        self.showPicker = showPicker
    }
    
    var itemCount : Int {
        return items.count
    }
    
    func getImage() -> UIImage? {
        return currentItem.getImage()
    }
    
    func getName() -> String {
        return currentItem.getName()
    }
    
    func getImageAt(_ position: Int) -> UIImage? {
        return items[position].getImage()
    }
    
    func getNameAt(_ position: Int) -> String {
        return items[position].getName()
    }
    
}

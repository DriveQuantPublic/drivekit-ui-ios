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

public protocol DKFilterItemDelegate : AnyObject {
    func onFilterItemSelected(filterItem: DKFilterItem)
}

public class DKFilterViewModel {
    
    let items: [DKFilterItem]
    private(set) var currentItem: DKFilterItem
    let showPicker: Bool
    weak var delegate: DKFilterItemDelegate?

    public init(items: [DKFilterItem], currentItem: DKFilterItem, showPicker: Bool, delegate: DKFilterItemDelegate) {
        self.items = items
        self.currentItem = currentItem
        self.showPicker = showPicker
        self.delegate = delegate
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
    
    func itemSelected(position: Int) {
        currentItem = items[position]
        self.delegate?.onFilterItemSelected(filterItem: currentItem)
    }
}

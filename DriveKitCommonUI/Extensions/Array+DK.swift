//
//  Array+DK.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 02/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation

extension Array {
    /// Allow access subscripting that returns nil when index is out of bounds
    ///  exemple: `myArray[safe: index]`
    public subscript(safe index: Index) -> Element? {
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
    
    /// Allow access subscripting that returns `defaultValue` when index is out of bounds
    ///  exemple: `myArray[index, default: 0]`
    public subscript(index: Index, default defaultValue: Element) -> Element {
        guard index >= 0 && index < self.count else {
            return defaultValue
        }
        return self[index]
    }
    
    /// Check if self is empty first and if not, insert its value at given `index`
    ///  into `otherArray`, otherwise do nothing
    public func appendIfNotEmpty(valueAtIndex index: Self.Index, into otherArray: inout Self) {
        if self.isEmpty == false {
            otherArray.append(self[index])
        }
    }
    
    /// Return the range of the array's valid indexes
    public var indexRange: Range<Self.Index> {
        self.startIndex..<self.endIndex
    }
}

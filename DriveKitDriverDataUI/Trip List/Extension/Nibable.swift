//
//  File.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 21/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

protocol Nibable {
    static var viewFromNib: Self { get }
    static var nib: UINib { get }
}

extension Nibable where Self: UIView {
    static var viewFromNib: Self {
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle.driverDataUIBundle)
    }
    
    fileprivate static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

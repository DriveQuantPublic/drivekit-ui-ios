// swiftlint:disable force_cast
//
//  File.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 21/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

public protocol Nibable {
    static var viewFromNib: Self { get }
    static var nib: UINib { get }
}

public extension Nibable where Self: UIView {
    static var viewFromNib: Self {
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
    static var nib: UINib {
#if SWIFT_PACKAGE
        let moduleName = String(reflecting: self).prefix { $0 != "." }
        let bundlePath = (Bundle.main.resourceURL ?? Bundle(for: self).resourceURL)?.appendingPathComponent("DriveKitUI_\(moduleName).bundle")
        let bundle = bundlePath.flatMap(Bundle.init(url:)) ?? Bundle(for: self)
#else
        let bundle = Bundle(for: self)
#endif
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    fileprivate static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

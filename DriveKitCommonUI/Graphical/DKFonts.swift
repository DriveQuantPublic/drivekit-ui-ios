//
//  DKFonts.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

@objc public protocol DKFonts {
    @objc var primaryFont : String { get }
    @objc var secondaryFont : String { get }
}

public class DKDefaultFonts :  DKFonts {
    public init() {}
    public var primaryFont : String { get { return "Roboto" }}
    public var secondaryFont : String { get { return "Roboto" }}
}


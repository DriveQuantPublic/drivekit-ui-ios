// swiftlint:disable all
//
//  DriveKitUI.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public class DriveKitUI: NSObject {
    @objc public static let shared = DriveKitUI()

    @objc public private(set) var colors: DKColors!
    @objc public private(set) var fonts: DKFonts!
    @objc public private(set) var overridedStringFileName: String?
    @objc public private(set) var analytics: DKAnalytics?
    private var tagKeyFromScreen: [String: String]
    private var tagFromKey: [String: String]

    private override init() {
        var tagKeyFromScreen = [String: String]()
        let screenTagsFilePath = Bundle.driveKitCommonUIBundle?.path(forResource: "AnalyticsScreenToTagKey", ofType: "plist")
        if let screenTagsFilePath = screenTagsFilePath, let screenTagsRootDictionary = NSDictionary(contentsOfFile: screenTagsFilePath) as? [String: [String: String]] {
            for screenTagsDictionary in screenTagsRootDictionary.values {
                for (key, value) in screenTagsDictionary {
                    tagKeyFromScreen[key] = value
                }
            }
        } else {
            print("Unable to load AnalyticsScreenToTagKey")
        }
        self.tagKeyFromScreen = tagKeyFromScreen

        var tagFromKey = [String: String]()
        let tagFromKeyFilePath = Bundle.driveKitCommonUIBundle?.path(forResource: "AnalyticsTags", ofType: "plist")
        if !DriveKitUI.loadTags(atPath: tagFromKeyFilePath, into: &tagFromKey) {
            print("Unable to load default AnalyticsTags")
        }
        self.tagFromKey = tagFromKey
    }

    public func initialize(colors: DKColors = DKDefaultColors(), fonts: DKFonts = DKDefaultFonts(), overridedStringsFileName: String? = nil) {
        self.colors = colors
        self.fonts = fonts
        self.overridedStringFileName = overridedStringsFileName
    }

    @objc(initialize) public func objc_initialize() {
        self.colors = DKDefaultColors()
        self.fonts = DKDefaultFonts()
        self.overridedStringFileName = nil
    }

    @objc public func configureColors(_ colors: DKColors) {
        self.colors = colors
    }

    @objc public func configureFonts(_ fonts: DKFonts) {
        self.fonts = fonts
    }

    @objc public func configureStringsFileName(_ overridedStringsFileName: String) {
        self.overridedStringFileName = overridedStringsFileName
    }

    @objc public func configureAnalytics(_ analytics: DKAnalytics?, tagsFileName: String? = nil) {
        self.analytics = analytics

        guard tagsFileName != nil else {
            return
        }
        let tagFromKeyFilePath = Bundle.main.path(forResource: tagsFileName, ofType: "plist")
        if !DriveKitUI.loadTags(atPath: tagFromKeyFilePath, into: &self.tagFromKey) {
            print("Unable to load analytics tags from file with name: \"\(tagsFileName!)\"")
        }
    }

    func getTagForScreen(_ viewController: DKUIViewController) -> String? {
        if let tagKey = self.tagKeyFromScreen[String(describing: type(of: viewController))], let tag = self.tagFromKey[tagKey], !tag.isEmpty {
            return tag
        }
        return nil
    }

    @objc public func trackScreen(_ viewController: DKUIViewController) {
        if let analytics = self.analytics, let tag = getTagForScreen(viewController) {
            analytics.trackScreen(tag, viewController: viewController)
        }
    }

    @objc public func trackScreen(tagKey: String, viewController: UIViewController) {
        if let analytics = self.analytics, let tag = self.tagFromKey[tagKey] {
            analytics.trackScreen(tag, viewController: viewController)
        }
    }

    private static func loadTags(atPath path: String?, into tagFromKey: inout [String: String]) -> Bool {
        let success: Bool
        if let tagFromKeyFilePath = path, let tagsFromKeyDictionary = NSDictionary(contentsOfFile: tagFromKeyFilePath) as? [String: String] {
            for (key, value) in tagsFromKeyDictionary {
                tagFromKey[key] = value
            }
            success = true
        } else {
            success = false
        }
        return success
    }
}

public extension Bundle {
    static let driveKitCommonUIBundle = Bundle(identifier: "com.drivequant.drivekit-common-ui")
}

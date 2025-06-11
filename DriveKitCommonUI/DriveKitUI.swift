//
//  DriveKitUI.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import CoreText

@objc public class DriveKitUI: NSObject {
    static let tag = "DriveKit UI"

    @objc public static let shared = DriveKitUI()
    public static let calendar = Calendar(identifier: .gregorian)

    @objc public private(set) var colors: DKColors = DKDefaultColors()
    @objc public private(set) var fonts: DKFonts = DKDefaultFonts()
    @objc public private(set) var overridedStringFileName: String?
    @objc public private(set) var analytics: DKAnalytics?
    private var tagKeyFromScreen: [String: String]
    private var tagFromKey: [String: String]
    
    private var internalScores: [DKScoreType] = [.safety, .ecoDriving, .distraction, .speeding]
    public var scores: [DKScoreType] {
        get {
            self.internalScores.filter { score in
                score.hasAccess()
            }
        }
        set {
            if newValue.isEmpty {
                self.internalScores = [.safety]
            } else {
                self.internalScores = newValue
            }
        }
    }

    private override init() {
        DriveKitLog.shared.infoLog(tag: DriveKitUI.tag, message: "Initialization")
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
        super.init()

        // Install custom fonts.
        if let paths = Bundle.driveKitCommonUIBundle?.paths(forResourcesOfType: "ttf", inDirectory: "") {
            for path in paths {
                let url = NSURL(fileURLWithPath: path)
                CTFontManagerRegisterFontsForURL(url, .process, nil)
            }
        }
    }

    public func initialize() {
        // Nothing to do currently.
    }

    @objc(initialize) public func objc_initialize() {
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
#if SWIFT_PACKAGE
    static let driveKitCommonUIBundle: Bundle? = Bundle.module
#else
    static let driveKitCommonUIBundle = Bundle(identifier: "com.drivequant.drivekit-common-ui")
#endif
}

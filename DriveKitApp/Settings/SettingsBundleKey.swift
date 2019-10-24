//
//  SettingsBundleKey.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 22/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation

struct SettingsBundleKeys {
    static let userIdPref = "user_id_preference"
    static let loggingPref = "logging_preference"
    static let sandboxPref = "sandbox_preference"
    static let autostartPref = "autostart_preference"
    static let timeoutPref = "timeout_preference"
    static let beaconRequiredPref = "beacon_required_preference"
    static let beaconConfigurationPref = "beacon_configured_preference"
    static let sharePositionPref = "share_position_enabled"
    static let defaultValuePref = "defaultValuePref"
    
    static let userDefaults = UserDefaults.standard
    
    static func setUserId(userId: String) {
        userDefaults.set(userId, forKey: userIdPref)
        userDefaults.synchronize()
    }
    
    static func getUserId() -> String? {
        if let userId = userDefaults.value(forKey: userIdPref) as! String? {
            return userId
        }
        return nil
    }
    
    static func setLoggingPref(logging: Bool) {
        userDefaults.set(logging, forKey: loggingPref)
        userDefaults.synchronize()
    }
    
    static func getLoggingPref() -> Bool {
        return userDefaults.bool(forKey: loggingPref)
    }
    
    static func setSandboxPref(sandbox: Bool) {
        userDefaults.set(sandbox, forKey: sandboxPref)
        userDefaults.synchronize()
    }
    
    static func getSandboxPref() -> Bool {
        return userDefaults.bool(forKey: sandboxPref)
    }
    
    static func setAutoStartPref(autoStart: Bool) {
        userDefaults.set(autoStart, forKey: autostartPref)
        userDefaults.synchronize()
    }
    
    static func getAutoStartPref() -> Bool {
        return userDefaults.bool(forKey: autostartPref)
    }
    
    static func setTimeoutPref(timeout: Int) {
        userDefaults.set(timeout, forKey: timeoutPref)
        userDefaults.synchronize()
    }
    
    static func getTimeoutPref() -> Int {
        return userDefaults.integer(forKey: timeoutPref)
    }
    
    static func setBeaconPref(required: Bool) {
        userDefaults.set(required, forKey: beaconRequiredPref)
        userDefaults.synchronize()
    }
    
    static func getBeaconPref() -> Bool {
        return userDefaults.bool(forKey: beaconRequiredPref)
    }
    
    static func setBeaconConfigPref(configurable: Bool) {
        userDefaults.set(configurable, forKey: beaconConfigurationPref)
        userDefaults.synchronize()
    }
    
    static func getBeaconConfigPref() -> Bool {
        return userDefaults.bool(forKey: beaconConfigurationPref)
    }
    
    static func setPositionPref(share: Bool) {
        userDefaults.set(share, forKey: sharePositionPref)
        userDefaults.synchronize()
    }
    
    static func getPositionPref() -> Bool {
        return userDefaults.bool(forKey: sharePositionPref)
    }
    
}

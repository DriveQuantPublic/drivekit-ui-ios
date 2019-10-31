//
//  NotifSender.swift
//  DriveQuant_SDK
//
//  Created by Jérémy Bayle on 08/07/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

public class NotificationSender : NSObject{
    
    static let delay = 2.0
    
    public static let shared = NotificationSender()
    
    private override init(){}
    
    public func sendNotification(message: String, userInfo: Dictionary<String,String>? = nil) {
        sendNotificationIOS10(message: message, userInfo: userInfo)
    }
    
    
    @available(iOS 10.0, *)
    func sendNotificationIOS10(message: String,
                               userInfo: Dictionary<String,String>? = nil) {
        let content = UNMutableNotificationContent()
        content.title = "DriveKit test app"
        content.body = message
        
        content.sound = UNNotificationSound.default
        
        if let userInfo = userInfo {
            content.userInfo = userInfo
        }
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: NotificationSender.delay, repeats: false)
        let request = UNNotificationRequest(identifier: "debug\(Int.random(in: 0...15000))",
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = NotificationSender.shared
        UNUserNotificationCenter.current().add(request) { error in
        }
    }
}

extension NotificationSender : UNUserNotificationCenterDelegate {
}

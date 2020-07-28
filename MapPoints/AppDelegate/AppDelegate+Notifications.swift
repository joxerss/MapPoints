//
//  AppDelegate+Notifications.swift
//  MapPoints
//
//  Created by Artem Syritsa on 25.06.2020.
//  Copyright © 2020 Artem. All rights reserved.
//

import Foundation
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    //$ xcrun simctl push D23AB050-3B07-48D9-BB06-EC0B80D76BE7 Artem.Syrytsia.MapPoints notification.apns
    //  xcrun simctl push D23AB050-3B07-48D9-BB06-EC0B80D76BE7 Artem.Syrytsia.MapPoints notification.apns
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
                print("⚠️ Permission granted: \(granted)")
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.init(arrayLiteral: [.alert, .badge, .sound]))
    }
    
}

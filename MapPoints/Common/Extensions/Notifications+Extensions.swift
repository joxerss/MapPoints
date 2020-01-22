//
//  UserManager + Notifications.swift
//  Protomate
//
//  Created by Artem on 27.11.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import Foundation

// MARK: - UserStatus Notifications

extension Notification.Name {
    
    static public let kLanguageChanged = Notification.Name("Language_Changed")
    static public let kMapPointsChanged = Notification.Name("MapPoints_Changed")
}

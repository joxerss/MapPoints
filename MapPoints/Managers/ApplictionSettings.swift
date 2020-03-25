//
//  ApplictionSettings.swift
//  MapPoints
//
//  Created by Artem Syritsa on 25.03.2020.
//  Copyright © 2020 Artem. All rights reserved.
//

import Foundation

class ApplictionSettings: NSObject {
    
    static let shared: ApplictionSettings = ApplictionSettings()
    
    // Should application track users location when application is in Background (ApplicationStateBackground).
    let shouldTrackLocationBG: Bool = true
    
    // Should system pauses tracking locaation automatically.
    let shouldSystemPausesLocationUpdates: Bool = false
    
    // Should application track users location when application is OFF (ApplicationStateInactive).
    let shouldTrackLocationOFF: Bool = true
    
    // MARK: - Life cycle
    
    private override init() {
        super.init()
    }
    
    // MARK: - Actions
    
}

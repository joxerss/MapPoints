//
//  AppleMapService.swift
//  Costless
//
//  Created by Artem Syrytsia on 11.09.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation
import CoreLocation

/// Map service which works with apple's build in map.
class AppleMapService: NSObject, MapService {
    
    // MARK: - Variables
    
    weak var dataSource: MapServiceDataSource?
    
    weak var delegate: MapServiceDelegate?
    
    required init(dataSource: MapServiceDataSource, delegate: MapServiceDelegate) {
        super.init()
        self.dataSource = dataSource
        self.delegate = delegate
        setupMap()
    }

}

extension AppleMapService {
    // MARK: - Setup
    
    private func setupMap() {
    
    }
    
    /// Use this func to show map's items on map.
    func reload() {
    
    }
    
    // MARK: - Actions
    
    func moveCameraToMarkers() {
        
    }
    
    func centrateCameraTo(_ position: CLLocationCoordinate2D) {
        
    }
    
    func toCurrentPosition() {
        
    }
    
}

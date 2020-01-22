//
//  MapViewDataSource.swift
//  Costless
//
//  Created by Artem Syrytsia on 11.09.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation

/// This protocol describes functions to provide data to map view.
protocol MapViewDataSource: class {
    func mapItemsForMap(_ map: MapView) -> [MapItem]
}

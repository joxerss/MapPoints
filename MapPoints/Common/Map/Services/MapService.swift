//
//  MapService.swift
//  Costless
//
//  Created by Artem Syrytsia on 11.09.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import CoreLocation

protocol MapServiceDataSource: class {
    func containerViewForMap() -> UIView
    var mapItems: [MapItem] { get }
}

protocol MapServiceDelegate: class {
    func userDidTapOnMarker(_ position: CLLocationCoordinate2D) -> Void
    func scrollMapToCoordinate(_ position: CLLocationCoordinate2D) -> Void
    func didChangeCameraPosition(_ position: CLLocationCoordinate2D) -> Void
    func userDidLongPressOn(_ position: CLLocationCoordinate2D) -> Void
    /// Hide cusstome location button if need thow controller
    func hideMyLocationButton(_ isHidden: Bool) -> Void
}

protocol MapItem: class {
    var coordinate: CLLocationCoordinate2D { get }
    var title: String { get }
    var iconImageName: String { get }
}

extension MapItem {
    var iconImageName: String { return "discount_card.pin_icon" }
}

/// Map service protocol which describes functions to work with other
/// map services. Use this protocol to describe new map service.
protocol MapService: NSObject {
    
    var dataSource: MapServiceDataSource? { get set }
    
    var delegate: MapServiceDelegate? { get set }
    
    init(dataSource: MapServiceDataSource, delegate: MapServiceDelegate)
    
    /// Use this func to show map's items on map.
    func reload()
    
    func moveCameraToMarkers()
    
    func centrateCameraTo(_ position: CLLocationCoordinate2D)
    
    func toCurrentPosition()
}


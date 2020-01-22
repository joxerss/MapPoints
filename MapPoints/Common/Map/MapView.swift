//
//  MapView.swift
//  Costless
//
//  Created by Artem Syrytsia on 11.09.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import CoreLocation

/// We need type enum because map can be switched to different map types in future.
enum MapType {
    case apple
    case google
}

/// MapView is a common map in costless platform. Use this map if you nieed followng features:
/// - Showing stores in map (with clustering)
/// - Switching between different map types.
/// -
class MapView: UIView {
    
    // MARK: - UI
    
    private(set) var currentLocationButton: UIButton!
    
    // MARK: - Variables
    
    private(set) var mapType: MapType!
    
    weak var delegate: MapViewDelegate?
    
    weak var dataSource: MapViewDataSource?
    
    // MARK: - Private variables
    
    private var mapService: MapService?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Setup
    
    private func setup() {
        // TODO: Make here map type picking.
        setupService(.google)
    }
    
    private func setupService(_ type: MapType) {
        switch type {
        case .apple:
            mapService = AppleMapService(dataSource: self, delegate: self)
        case .google:
            mapService = GoogleMapService(dataSource: self, delegate: self)
        }
    }
    
    // MARK: - Actions (overrides)
    
    /// Call this func to show markers in map. Be sure that func mapItemsForMap is implemented.
    func reloadData() {
        mapService?.reload()
        mapService?.moveCameraToMarkers()
    }
    
    /// This func will transfer map camera over all markers and you can see all markers in view
    func showMarkers() {
        mapService?.moveCameraToMarkers()
    }
    
    // MARK: - Actions
    
    @objc func toCurrentPosition(_ sender: UIButton) -> Void {
        mapService?.toCurrentPosition()
    }
    
    // MARK: - Other
    
    
}

// MARK: - MapServiceDataSource

extension MapView: MapServiceDataSource {
    func containerViewForMap() -> UIView {
        return self
    }
    
    var mapItems: [MapItem] {
        return dataSource?.mapItemsForMap(self) ?? []
    }
}

// MARK: - MapServiceDelegate

extension MapView: MapServiceDelegate {
    func hideMyLocationButton(_ isHidden: Bool) {
        delegate?.hideMyLocationButton(isHidden)
    }
    
    func userDidTapOnMarker(_ position: CLLocationCoordinate2D) {
        delegate?.userDidTapOnMarker(position)
    }
    
    func scrollMapToCoordinate(_ position: CLLocationCoordinate2D) {
        mapService?.centrateCameraTo(position)
    }
    
    func didChangeCameraPosition(_ position: CLLocationCoordinate2D) {
        delegate?.didChangeCameraPosition(position)
    }
    
    
    func userDidLongPressOn(_ position: CLLocationCoordinate2D) -> Void {
        delegate?.userDidLongPressOn(position)
    }
}

// MARK: - Constants

extension MapView {
    static var bottomInset: CGFloat { return 15.0 }
}

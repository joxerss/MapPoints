//
//  GoogleMapService.swift
//  Costless
//
//  Created by Artem Syrytsia on 11.09.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

/// Map service which works with google map.
class GoogleMapService: NSObject, MapService {

    // MARK: - Variables
    
    weak var dataSource: MapServiceDataSource?
    
    weak var delegate: MapServiceDelegate?
    
    // MARK: - Private variables
    
    fileprivate var googleMap: GMSMapView!
    
    fileprivate var clusterManager: GMUClusterManager!
    fileprivate var renderer: GMUDefaultClusterRenderer!
    
    fileprivate var cameraDidSetup = false
    
    // MARK: - Lifecycle
    
    required init(dataSource: MapServiceDataSource, delegate: MapServiceDelegate) {
        super.init()
        self.dataSource = dataSource
        self.delegate = delegate
        setupMap()
    }
    
    deinit {
        releaseMemory()
    }
    
    func releaseMemory() {
        if let mapView = googleMap, let renderer = clusterManager {

            renderer.clearItems()
            mapView.clear()
            mapView.delegate = nil
            mapView.removeFromSuperview()

        }

        clusterManager = nil
        renderer = nil
        googleMap = nil
    }
    
}

// MARK: - Setup

fileprivate extension GoogleMapService {
    
    /// In this func we create google map, create cluster manager and then we add google map into
    /// containerViewForMap.
    func setupMap() {
        
        guard let sourceView = dataSource?.containerViewForMap() else {
            assertionFailure("⚠️ GoogleMapService containerViewForMap can't bee nil !!!")
            return
        }
        
//        let camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
//        googleMap = GMSMapView(frame: sourceView.bounds, camera: camera)
        googleMap = GMSMapView(frame: sourceView.bounds)
        googleMap.isMyLocationEnabled = true
        
        googleMap.delegate = self
//        googleMap.mapStyle = try? GMSMapStyle(jsonString: GMSMapView.jsonStringOfDefaultStyle)
        
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: GMUDefaultClusterIconGenerator.defaultBuckets,
                                                           backgroundColors: Array.init(repeating: UIColor.orange, count: 10))
        renderer = GMUDefaultClusterRenderer(mapView: googleMap, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(map: googleMap, algorithm: GMUNonHierarchicalDistanceBasedAlgorithm(), renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)
        
        sourceView.addSubview(googleMap)
        
        googleMap.translatesAutoresizingMaskIntoConstraints = false
        googleMap.topAnchor.constraint(equalTo: sourceView.topAnchor, constant: 0).isActive=true
        googleMap.leftAnchor.constraint(equalTo: sourceView.leftAnchor).isActive=true
        googleMap.rightAnchor.constraint(equalTo: sourceView.rightAnchor).isActive=true
        googleMap.bottomAnchor.constraint(equalTo: sourceView.bottomAnchor).isActive=true
        googleMap.layoutIfNeeded()
    }
}

// MARK: - Actions

extension GoogleMapService {
    
    /// Use this func to show map's items on map.
    func reload() {
        // remove all point on map
        clusterManager.clearItems()
        googleMap.clear()
        
        googleMap.settings.compassButton = true
        googleMap.settings.myLocationButton = true
        
        if let items = dataSource?.mapItems {
            clusterManager.add(items.map { MarkerItem(mapItem: $0) })
            clusterManager.cluster()
        }
    }
    
    func moveCameraToMarkers() {
        if let items = dataSource?.mapItems, items.count > 0 {
            cameraDidSetup = false
            
            let firstItem = items.first! // Need to init GMSCoordinateBounds
            
            if items.count == 1 {
                let cameraPosition = GMSCameraPosition.camera(withTarget: firstItem.coordinate, zoom: googleMap.camera.zoom)
                googleMap.animate(to: cameraPosition)
                return
            }
            
            var bounds = GMSCoordinateBounds(coordinate: firstItem.coordinate, coordinate: firstItem.coordinate)
            items.forEach { (mapItem) in
                bounds = bounds.includingCoordinate(mapItem.coordinate)
            }
            googleMap.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 10.0))
        }
    }
    
    func centrateCameraTo(_ position: CLLocationCoordinate2D) {
        let cameraPosition = GMSCameraPosition.camera(withTarget: position, zoom: 16.0/*googleMap.camera.zoom*/)
        googleMap.animate(to: cameraPosition)
    }
    
    func toCurrentPosition() {
        guard let coordinate = googleMap.myLocation?.coordinate else {
            return
        }
        let cameraPosition = GMSCameraPosition.camera(withTarget: coordinate, zoom: 12.0)
        googleMap.animate(to: cameraPosition)
    }
}

// MARK: - GMSMapViewDelegate

extension GoogleMapService: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        delegate?.userDidTapOnMarker(marker.position)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if cameraDidSetup == false {
            cameraDidSetup = true
            return
        }
        // Position of camera didChange
        delegate?.didChangeCameraPosition(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // remove custome view
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // custome view
        let infoView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        infoView.backgroundColor = .firebaseLogoFrontColor
        infoView.textAlignment = .center
        if let markerItem = marker.userData as? MarkerItem {
            infoView.text = markerItem.mapItem.title
        }
        return infoView
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        delegate?.userDidLongPressOn(coordinate)
    }
    
}

// MARK: - GMUClusterManagerDelegate

extension GoogleMapService: GMUClusterManagerDelegate {
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let cameraPosition = GMSCameraPosition.camera(withTarget: cluster.position, zoom: googleMap.camera.zoom /*+ 1*/)
        let update = GMSCameraUpdate.setCamera(cameraPosition)
        googleMap.moveCamera(update)
        return false
    }
}

// MARK: - GMUClusterRendererDelegate

extension GoogleMapService: GMUClusterRendererDelegate {
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        if let markerItem = object as? MarkerItem {
            let marker = GMSMarker(position: markerItem.position)
            marker.icon = UIImage(named: markerItem.iconName)
            return marker
        }
        return nil
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        marker.appearAnimation = .none
    }
}

/// This object will be added to cluster generator as item which should be shown on map.

fileprivate class MarkerItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D { return mapItem.coordinate }
    var iconName: String { return mapItem.iconImageName }
    let mapItem: MapItem
    init(mapItem: MapItem) {
        self.mapItem = mapItem
    }
}

// MARK: - Extension of GMSMapView

extension GMSMapView {
    static var jsonStringOfDefaultStyle: String { return "[{\"featureType\": \"poi\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"road\",\"elementType\": \"labels.icon\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"administrative\",\"elementType\": \"geometry\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"transit\",\"stylers\": [{\"visibility\": \"off\"}]}]" }
}

// MARK: - Extension of GMUDefaultClusterIconGenerator

extension GMUDefaultClusterIconGenerator {
    static var defaultBuckets: [NSNumber] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 99]
}

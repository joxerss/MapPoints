//
//  LocationManager.swift
//  MapPoints
//
//  Created by Artem Syritsa on 25.03.2020.
//  Copyright © 2020 Artem. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    static let shared: LocationManager = LocationManager()
    
    /// Lcation manager will init and start in lazy var.
    lazy var locationManager: CLLocationManager = {
        print("🧭 LocationManager init locationManager thow lazy var.");
        var manager: CLLocationManager = CLLocationManager()
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = ApplictionSettings.shared.shouldTrackLocationBG
        manager.pausesLocationUpdatesAutomatically = ApplictionSettings.shared.shouldSystemPausesLocationUpdates
        
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 10
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        if(ApplictionSettings.shared.shouldTrackLocationOFF &&
            CLLocationManager.significantLocationChangeMonitoringAvailable()){
            manager.startMonitoringSignificantLocationChanges()
        } else {
            print("🧭 LocationManager startMonitoringSignificantLocationChanges: \(ApplictionSettings.shared.shouldTrackLocationOFF) | should it track:  \(CLLocationManager.significantLocationChangeMonitoringAvailable())")
        }
        
        return manager
    }()
    
    // MARK: - Life cycle
    
    private override init() {
        super.init()
        self.validateIsLcoationServicesEnabled()
    }
    
    // MARK: - Actions
    
    public func reinitLocationManager() {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
        
        let manager: CLLocationManager = CLLocationManager()
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = ApplictionSettings.shared.shouldTrackLocationBG
        manager.pausesLocationUpdatesAutomatically = ApplictionSettings.shared.shouldSystemPausesLocationUpdates
        
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 10
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        if(ApplictionSettings.shared.shouldTrackLocationOFF &&
            CLLocationManager.significantLocationChangeMonitoringAvailable()){
            manager.startMonitoringSignificantLocationChanges()
        } else {
            print("🧭 LocationManager startMonitoringSignificantLocationChanges: \(ApplictionSettings.shared.shouldTrackLocationOFF) | should it track:  \(CLLocationManager.significantLocationChangeMonitoringAvailable())")
        }
        
        locationManager = manager
        print("🧭 LocationManager reinitLocationManager locationManager.");
    }
    
    public func stopTrackingLocation() {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Validations
    
    func validateIsLcoationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            print("🧭 LocationManager locationServicesEnabled");
            return
        }
        
        Material.showMaterialAlert(title: "🧭 LocationManager", message: "Location Services Disabled, please turn it on in capabilities")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("🧭 LocationManager didUpdateLocations | Application state \(UIApplication.shared.applicationState.rawValue)")
        for location in locations {
            let time = Date()
            let timeFormater = DateFormatter()
            timeFormater.dateFormat = "MMM E d, yyyy | h:mm a"
            let timeString = timeFormater.string(from: time)
            
            let firebaseObject = Location.init(name: timeString, location: location.coordinate)
            FirebaseDatastore.shared.addPoint(json: firebaseObject.toJson())
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🧭 LocationManager didFailWithError: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("🧭 LocationManager didChangeAuthorization status: \(status.rawValue)")
//        switch status {
//        case .authorizedAlways:
//            <#code#>
//        case .authorizedWhenInUse:
//            <#code#>
//        case .denied:
//            <#code#>
//        case .restricted, .notDetermined:
//            <#code#>
//        }
    }
    
}

//
//  Point.swift
//  MapPoints
//
//  Created by Artem on 31.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class Point: NSObject {
    
    var long: NSNumber?
    var lat: NSNumber?
    
    var cooredinate: CLLocationCoordinate2D {
        let latitudeDegrees: CLLocationDegrees = lat?.doubleValue ?? 0
        let longitudeDegrees: CLLocationDegrees = long?.doubleValue ?? 0
        return CLLocationCoordinate2D(latitude: latitudeDegrees, longitude: longitudeDegrees)
    }

    init(with json: Dictionary<String, Any>) {
        super.init()
        long = json["longitude"] as? NSNumber
        lat = json["latitude"] as? NSNumber
    }
    
    func toJson() -> Dictionary<String, Any> {
        return [ "longitude" : long ?? "",
                 "latitude": lat ?? "" ]
    }
    
    init(location: CLLocationCoordinate2D){
        super.init()
        long = location.longitude as NSNumber
        lat = location.latitude as NSNumber
    }
}

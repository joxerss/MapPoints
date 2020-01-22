//
//  Location.swift
//  MapPoints
//
//  Created by Artem on 31.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class Location: NSObject {

    var name: String?
    var point: Point?
    
    init(with json: Dictionary<String, Any>) {
        super.init()
        name = json["name"] as? String
        if let json = json["point"] as? Dictionary<String, Any> {
            point = Point.init(with: json)
        }
    }
    
    init(name: String, location: CLLocationCoordinate2D) {
        super.init()
        self.name = name
        point = Point.init(location: location)
    }
    
    func toJson() -> Dictionary<String, Any> {
        return [ "name" : name ?? "" ,
                 "point" : point?.toJson() ?? "" ]
    }
    
}


extension Location: MapItem {
    var coordinate: CLLocationCoordinate2D {
        return point?.cooredinate ?? CLLocationCoordinate2DMake(0, 0)
    }
    var title: String { return name ?? "none" }
}

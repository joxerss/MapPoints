//
//  Locations.swift
//  MapPoints
//
//  Created by Artem on 31.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class Locations: NSObject {

    var list: Array<Location>? {
        didSet {
            NotificationCenter.default.post(name: .kMapPointsChanged, object: nil)
        }
    }
    
    override init() {
        list = Array()
    }
    
    init(with jsonArray: Array<Dictionary<String, Any>>) {
        super.init()
        
        list = Array()
        jsonArray.forEach { (dict) in
            let location: Location = Location.init(with: dict)
            list?.append(location)
        }
    }
    
    
}

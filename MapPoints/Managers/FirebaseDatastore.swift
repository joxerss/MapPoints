//
//  FirebaseDatastore.swift
//  MapPoints
//
//  Created by Artem on 29.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import Firebase

class FirebaseDatastore: NSObject {
    

    private let kLocations = "Locations"
    static let shared: FirebaseDatastore = FirebaseDatastore()
    
    var listLocations: Locations? {
        didSet {
            NotificationCenter.default.post(name: .kMapPointsChanged, object: nil)
        }
    }
    
    // Get a reference to the database service
    lazy var reference: DatabaseReference! = {
        return Database.database().reference()
    }()
    
    private override init() {
        super.init()
        observeDatabase()
    }
    
    func observeDatabase() -> Void {
        self.listLocations = Locations()
        
        reference.child(kLocations).observe(.value) { [weak self] (snapshot) in
            guard let jsonLocations = snapshot.value as? Array<Dictionary<String, Any>> else {
                print("⚠️❌ Firebase Realtime Database incorrect locations data")
                return
            }
            self?.listLocations = Locations.init(with: jsonLocations)
        }
        
//        reference.child(kLocations).observe(.childAdded) { [weak self] (snapshot) in
//            guard let jsonLocation = snapshot.value as? Dictionary<String, Any> else {
//                print("⚠️❌ Firebase Realtime Database incorrect locations data")
//                return
//            }
//            self?.listLocations?.list?.append(Location.init(with: jsonLocation))
//        }
        
        reference.child(kLocations).observe(.childRemoved) { [weak self] (snapshot) in
            if let jsonLocation = snapshot.value as? Dictionary<String, Any> {
                 let location = Location(with: jsonLocation)
                self?.listLocations?.list?.removeAll(where: { $0.name == location.name })
            } else if let jsonLocations = snapshot.value as? Array<Dictionary<String, Any>> {
                self?.listLocations = Locations.init(with: jsonLocations)
            }
        }
    }
    
    func removeLocations() {
        reference.child(kLocations).removeValue()
    }
    
    func restorePoints() {
        if let path = Bundle.main.path(forResource: "firbaseBackup", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                            // do stuff
                    reference.setValue(jsonResult)
                  }
              } catch {
                   // handle error
              }
        }
    }
    
    func addPoint(json: Dictionary<String, Any>) {
        var list:  Array<Dictionary<String, Any>> = Array()
        listLocations?.list?.forEach({ (location) in
            list.append(location.toJson())
        })
        list.append(json)
        reference.child(kLocations).setValue(list)
    }
    
}

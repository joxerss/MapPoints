//
//  MapViewController.swift
//  MapPoints
//
//  Created by Artem on 02.01.2020.
//  Copyright © 2020 Artem. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: BaseController {

    @IBOutlet weak var mapView: MapView!
    var mapItems: [MapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.dataSource = self
        mapView.delegate = self
        mapView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(needUpdateCounteiners(_:)), name: .kMapPointsChanged, object: nil)
    }
    
    func scrollToLocation(_ location: Location) {
        let coord = location.coordinate
        mapView.scrollMapToCoordinate(coord)
    }
    
    @objc func needUpdateCounteiners(_ notification: Notification?) {
        self.showAnimatedLoader()
        self.mapView.reloadData()
    }
    
    

}

extension MapViewController: MapViewDataSource, MapViewDelegate {
    func mapItemsForMap(_ map: MapView) -> [MapItem] {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.hideAnimatedLoader()
        }
        return FirebaseDatastore.shared.listLocations?.list
            ?? []
    }
    
    func userDidTapOnMarker(_ position: CLLocationCoordinate2D) {
        mapView.scrollMapToCoordinate(position)
    }
    
    func didChangeCameraPosition(_ position: CLLocationCoordinate2D) {
        
    }
    
    func hideMyLocationButton(_ isHidden: Bool) {
        
    }
    
    func userDidLongPressOn(_ position: CLLocationCoordinate2D) -> Void {
        MainCoordinator.shared.presentCrationPoint(in: self, point: position)
    }
}

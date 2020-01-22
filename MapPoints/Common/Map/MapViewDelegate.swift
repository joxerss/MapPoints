//
//  MapViewDelegate.swift
//  Costless
//
//  Created by Artem Syrytsia on 11.09.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation
import CoreLocation

/// Override methods in ViewController  for getting notification from Map.
///
/// - Example: When user did tap on marker.
protocol MapViewDelegate: class {
    func userDidTapOnMarker(_ position: CLLocationCoordinate2D) -> Void
    func didChangeCameraPosition(_ position: CLLocationCoordinate2D) -> Void
    func userDidLongPressOn(_ position: CLLocationCoordinate2D) -> Void
    /// Hide cusstome location button if need thow controller
    func hideMyLocationButton(_ isHidden: Bool) -> Void
}

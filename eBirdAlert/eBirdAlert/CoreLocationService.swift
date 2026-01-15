// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Schema

class CoreLocationService: LocationService {
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startMonitoringSignificantLocationChanges()
        default:
            locationManager.stopMonitoringSignificantLocationChanges()
        }
    }

    func locationManager(_: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else { return }
        Task { @MainActor in
            self.location =
                Coordinate(latitude: location.coordinate.latitude,
                           longitude: location.coordinate.longitude)
        }
    }
}

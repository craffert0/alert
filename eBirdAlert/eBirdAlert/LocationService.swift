// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Observation

@Observable
class LocationService: NSObject {
    static var global = LocationService()

    private let locationManager = CLLocationManager()
    private(set) var location: CLLocation? = nil

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationService: CLLocationManagerDelegate {
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
        DispatchQueue.main.async {
            self.location = location
        }
    }

    func locationManager(_: CLLocationManager,
                         didFailWithError error: any Error)
    {
        print("fuck", error.localizedDescription)
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit

protocol LocationProtocol {
    var locName: String { get }
    var lat: Double { get }
    var lng: Double { get }
}

extension LocationProtocol {
    func openMap() {
        let prefs = PreferencesModel.global
        switch prefs.mapType {
        case .apple:
            let coordinate = CLLocationCoordinate2DMake(lat, lng)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = locName
            var launchOptions: [String: Any] = [:]
            if let key = prefs.directionsType.appleDirectionsKey {
                launchOptions[MKLaunchOptionsDirectionsModeKey] = key
            }
            mapItem.openInMaps(launchOptions: launchOptions)
        case .google:
            // https://developers.google.com/maps/documentation/urls/ios-urlscheme
            if let key = prefs.directionsType.googleDirectionsKey {
                UIApplication.shared.open(
                    URL(string:
                        "comgooglemaps://?daddr=\(lat),\(lng)&directionsmode=\(key)")!
                )
            } else {
                UIApplication.shared.open(
                    URL(string:
                        "https://www.google.com/maps/place/\(lat),\(lng)/@\(lat),\(lng),17z")!
                )
            }
        }
    }
}

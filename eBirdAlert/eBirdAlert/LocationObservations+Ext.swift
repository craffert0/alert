// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

extension LocationObservations: @retroactive Identifiable {
    public var id: String { locId }
}

extension LocationObservations {
    func openMap() {
        switch PreferencesModel.global.mapOption {
        case .apple:
            let coordinate = CLLocationCoordinate2DMake(lat, lng)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = locName
            mapItem.openInMaps()
        case .google:
            // TODO: this should have a much better name & pin
            UIApplication.shared.open(
                URL(string: "https://www.google.com/maps/@\(lat),\(lng),17z")!
            )
        }
    }
}

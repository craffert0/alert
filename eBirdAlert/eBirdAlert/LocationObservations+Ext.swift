// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

extension LocationObservations: @retroactive Identifiable {
    public var id: String { locId }
}

extension LocationObservations {
    var appleMapItem: MKMapItem {
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locName
        return mapItem
    }

    var googleMapURL: URL {
        // TODO: this should have a much better name & pin
        URL(string: "https://www.google.com/maps/@\(lat),\(lng),12z")!
    }
}

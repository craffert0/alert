// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import UIKit

protocol LocationProtocol {
    var locName: String { get }
    var lat: Double { get }
    var lng: Double { get }
    var hotspotId: String? { get }
}

extension LocationProtocol {
    func openMap() {
        UIApplication.shared.open(URL(string: mapString())!)
    }

    private func mapString() -> String {
        let prefs = PreferencesModel.global
        let latlng = "\(lat),\(lng)"

        return switch prefs.mapType {
        case .apple:
            if let key = prefs.directionsType.appleDirectionsKey {
                "https://maps.apple.com/directions?destination=\(latlng)&mode=\(key)"
            } else if let name = locName.encoded, !name.isEmpty {
                "https://maps.apple.com/place?coordinate=\(latlng)&name=\(name)"
            } else {
                "https://maps.apple.com/place?coordinate=\(latlng)"
            }
        case .google:
            // https://developers.google.com/maps/documentation/urls/ios-urlscheme
            if let key = prefs.directionsType.googleDirectionsKey {
                "comgooglemaps://?daddr=\(latlng)&directionsmode=\(key)"
            } else {
                "https://www.google.com/maps/place/\(latlng)/@\(latlng),17z"
            }
        }
    }
}

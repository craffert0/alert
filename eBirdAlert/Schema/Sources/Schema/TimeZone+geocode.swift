// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import MapKit

extension TimeZone {
    static func from(latitude: Double, longitude: Double) async -> TimeZone {
        // nb: this #available MUST be in its own test
        if #available(iOS 26.0, macOS 26.0, *) {
            if let request = MKReverseGeocodingRequest(
                location: .init(latitude: latitude, longitude: longitude)
            ),
                let first = try? await request.mapItems.compactMap(\.timeZone).first
            {
                return first
            }
        }
        return .current
    }
}

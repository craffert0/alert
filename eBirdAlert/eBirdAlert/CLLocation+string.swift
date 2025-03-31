// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation

extension CLAuthorizationStatus {
    var string: String {
        switch self {
        case .notDetermined: "not determined"
        case .restricted: "restricted"
        case .denied: "denied"
        case .authorizedWhenInUse: "authorized when in use"
        case .authorizedAlways: "authorized always"
        default: "unknown"
        }
    }
}

extension CLAccuracyAuthorization {
    var string: String {
        switch self {
        case .fullAccuracy: "full accuracy"
        case .reducedAccuracy: "reduced accuracy"
        default: "unknown"
        }
    }
}

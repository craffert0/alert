// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit

enum MapDirectionsOption: String {
    case none
    case walking
    case driving
    case transit
}

extension MapDirectionsOption: CaseIterable, Identifiable {
    var id: Self { self }
}

extension MapDirectionsOption {
    var appleDirectionsKey: String? {
        switch self {
        case .none: nil
        case .walking: MKLaunchOptionsDirectionsModeWalking
        case .driving: MKLaunchOptionsDirectionsModeDriving
        case .transit: MKLaunchOptionsDirectionsModeTransit
        }
    }

    var googleDirectionsKey: String? {
        self == .none ? nil : rawValue
    }
}

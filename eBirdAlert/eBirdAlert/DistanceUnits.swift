// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum DistanceUnits: String {
    case miles
    case kilometers

    func asMiles(_ value: Double) -> Double {
        switch self {
        case .miles: value
        case .kilometers: value / 1.61
        }
    }

    func asKilometers(_ value: Double) -> Double {
        switch self {
        case .miles: value * 1.61
        case .kilometers: value
        }
    }
}

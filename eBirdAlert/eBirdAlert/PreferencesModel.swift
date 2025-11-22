// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import Schema
import SwiftUI

class PreferencesModel: ObservableObject {
    static let global = PreferencesModel()

    @AppStorage("settings.daysBack") var daysBack: Int = 2
    @AppStorage("settings.rangeOption") var rangeOption: RangeOption = .radius
    @AppStorage("settings.distValue") var distValue: Double = 3
    @AppStorage("settings.distUnits") var distUnits: DistanceUnits = .miles
    @AppStorage("settings.mapType") var mapType: MapOption = .apple
    @AppStorage("settings.mapDirectionsType")
    var directionsType: MapDirectionsOption = .none
    @Published var debugMode: Bool = false
    let maxDistance: Double = 250

    // TODO: implement me.
    @Published var region: eBirdRegion? = .kings
    @Published var regionInfo: eBirdRegionInfo? = .kings
}

extension PreferencesModel {
    var geoQueryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "detail", value: "full"),
            URLQueryItem(name: "hotspot", value: "false"),
            URLQueryItem(name: "back", value: "\(daysBack)"),
            URLQueryItem(name: "dist",
                         value: "\(distUnits.asKilometers(distValue))"),
        ]
    }
}

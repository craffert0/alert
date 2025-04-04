// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import SwiftUI

class PreferencesModel: ObservableObject {
    static let global = PreferencesModel()

    @AppStorage("settings.daysBack") var daysBack: Int = 2
    @AppStorage("settings.distValue") var distValue: Double = 3
    @AppStorage("settings.distUnits") var distUnits: DistanceUnits = .miles
    @AppStorage("settings.applicationKey") var applicationKey: String = ""
    @AppStorage("settings.mapType") var mapOption: MapOption = .apple
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

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import SwiftUI

class PreferencesModel: ObservableObject {
    static let global = PreferencesModel()

    @AppStorage("settings.daysBack") var daysBack: Int = 2
    @AppStorage("settings.distMiles") var distMiles: Int = 3
    @AppStorage("settings.applicationKey") var applicationKey: String = ""
    @AppStorage("settings.mapType") var mapOption: MapOption = .apple
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct PreferencesModel {
    @AppStorage(wrappedValue: "", .settingsApplicationKey)
    var applicationKey: String

    static let global = PreferencesModel()
}

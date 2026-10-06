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
        PreferencesModel.global.mapURL(lat: String(lat),
                                       lng: String(lng),
                                       locName: locName)
    }
}

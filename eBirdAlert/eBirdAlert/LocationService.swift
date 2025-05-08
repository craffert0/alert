// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Observation

@Observable
class LocationService: NSObject {
    var location: CLLocation? = nil
}

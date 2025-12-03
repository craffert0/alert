// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation

public protocol CensusService {
    func getCensusTract(for location: CLLocation) async throws -> CensusTract
}

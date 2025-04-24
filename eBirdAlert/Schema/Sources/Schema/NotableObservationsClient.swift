// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Foundation

public class NotableObservationsClient {
    let service: eBirdService

    public init(service: any eBirdService) {
        self.service = service
    }
}

extension NotableObservationsClient: ObservationsClient {
    public func get(near location: CLLocation) async throws
        -> [eBirdObservation]
    {
        try await service.getNotable(near: location)
    }
}

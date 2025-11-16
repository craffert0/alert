// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Foundation

public final class eBirdRegionInfo: Codable, Sendable {
    public let bounds: Bounds?
    public let result: String
    public let code: String
    public let type: eBirdRegionType
    public let parent: eBirdRegionInfo?
    public let longitude: Double
    public let latitude: Double

    public struct Bounds: Codable, Sendable {
        public let minX: Double
        public let maxX: Double
        public let minY: Double
        public let maxY: Double
    }

    init(
        bounds: Bounds? = nil,
        result: String,
        code: String,
        type: eBirdRegionType,
        parent: eBirdRegionInfo? = nil,
        longitude: Double = 0.0,
        latitude: Double = 0.0
    ) {
        self.bounds = bounds
        self.result = result
        self.code = code
        self.type = type
        self.parent = parent
        self.longitude = longitude
        self.latitude = latitude
    }
}

extension eBirdRegionInfo: Identifiable {
    public var id: String { code }
}

extension eBirdRegionInfo {
    func contains(_ location: CLLocation) -> Bool {
        guard let bounds else { return true }
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        return
            bounds.minX - 0.14 <= lng &&
            lng <= bounds.maxX + 0.14 &&
            bounds.minY - 0.14 <= lat &&
            lat <= bounds.maxY + 0.14
    }
}

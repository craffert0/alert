// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

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

    public init(
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

public extension eBirdRegionInfo {
    static let world = eBirdRegionInfo(
        result: "World",
        code: "world",
        type: .custom
    )
}

extension eBirdRegionInfo: Identifiable {
    public var id: String { code }
}

extension eBirdRegionInfo {
    func touches(_ span: CoordinateSpan,
                 around location: Coordinate) -> Bool
    {
        guard let bounds else { return true }
        let lat = location.latitude
        let lng = location.longitude
        let dLat = span.latitudeDelta
        let dLng = span.longitudeDelta
        return
            bounds.minX - dLng <= lng &&
            lng <= bounds.maxX + dLng &&
            bounds.minY - dLat <= lat &&
            lat <= bounds.maxY + dLat
    }

    func within(_ span: CoordinateSpan,
                around location: Coordinate) -> Bool
    {
        guard let bounds else { return true }
        let lat = location.latitude
        let lng = location.longitude
        let dLat = span.latitudeDelta
        let dLng = span.longitudeDelta

        return
            lng - dLng <= bounds.minX &&
            bounds.maxX <= lng + dLng &&
            lat - dLat <= bounds.minY &&
            bounds.maxY <= lat + dLat
    }
}

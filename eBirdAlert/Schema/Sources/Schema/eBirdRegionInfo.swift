// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public final class eBirdRegionInfo: Codable, Sendable {
    public let bounds: Bounds?
    public let result: String
    public let code: String
    public let type: eBirdRegionType
    public let longitude: Double
    public let latitude: Double
    public let subregionCodes: [String]?
    public weak let parent: eBirdRegionInfo?

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
        longitude: Double = 0.0,
        latitude: Double = 0.0,
        subregionCodes: [String]? = nil,
        parent: eBirdRegionInfo? = nil
    ) {
        self.bounds = bounds
        self.result = result
        self.code = code
        self.type = type
        self.longitude = longitude
        self.latitude = latitude
        self.subregionCodes = subregionCodes
        self.parent = parent
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

public extension eBirdRegionInfo {
    // Is the location inside this region?
    func contains(location: Coordinate) -> Bool {
        guard let bounds else { return false }
        return bounds.minX < location.longitude &&
            bounds.maxX > location.longitude &&
            bounds.minY < location.latitude &&
            bounds.maxY > location.latitude
    }

    // Does this region overlap at allwith the box defined by span & location?
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

    // Is this region contained within the box defined by span & location?
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

private extension eBirdRegionInfo {
    func subName(of child: eBirdRegionInfo) -> String {
        String(child.result.prefix(child.result.count - (2 + result.count)))
    }
}

public extension eBirdRegionInfo {
    var grandParent: eBirdRegionInfo? { parent?.parent }

    var fullName: String { result }

    var regionalName: String {
        grandParent?.subName(of: self) ?? parent?.subName(of: self) ?? result
    }

    var shortName: String {
        parent?.subName(of: self) ?? result
    }
}

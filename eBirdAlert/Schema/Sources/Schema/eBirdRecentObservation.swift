// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct eBirdRecentObservation: Sendable {
    public let speciesCode: String
    public let comName: String
    public let sciName: String
    public let locId: String
    public let locName: String
    public let obsDt: Date
    public let howMany: Int?
    public let lat: Double
    public let lng: Double
    // public let obsValid: Bool
    // public let obsReviewed: Bool
    public let locationPrivate: Bool
    public let subId: String
}

public extension eBirdRecentObservation {
    init(dto: eBirdRecentObservationDTO) async {
        let timeZone =
            await TimeZone.from(latitude: dto.lat, longitude: dto.lng)

        speciesCode = dto.speciesCode
        comName = dto.comName
        sciName = dto.sciName
        locId = dto.locId
        locName = dto.locName
        obsDt = dto.obsDt.asDate(in: timeZone) ?? .now
        howMany = dto.howMany
        lat = dto.lat
        lng = dto.lng
        locationPrivate = dto.locationPrivate
        subId = dto.subId
    }
}

public extension [eBirdRecentObservation] {
    init(dtos: [eBirdRecentObservationDTO]) async throws {
        self.init()
        for dto in dtos {
            await append(.init(dto: dto))
        }
    }
}

public extension eBirdRecentObservation {
    static let fake = eBirdRecentObservation(
        speciesCode: "species",
        comName: "My Fancy Species",
        sciName: "Specious Reasoning",
        locId: "backyard",
        locName: "My Backyard",
        obsDt: Date.now,
        howMany: 4,
        lat: 40.7,
        lng: -74.0,

        locationPrivate: false,
        subId: "subid"
    )
}

public extension [eBirdRecentObservation] {
    // periphery:ignore - used in #Preview
    static let fake = [eBirdRecentObservation.fake]
}

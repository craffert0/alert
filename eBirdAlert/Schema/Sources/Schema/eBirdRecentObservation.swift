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
    public let timeZone: TimeZone
}

public extension eBirdRecentObservation {
    init(dto: eBirdRecentObservationDTO,
         timeZone: TimeZone)
    {
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
        self.timeZone = timeZone
    }
}

public extension [eBirdRecentObservation] {
    static func from(dtos: [eBirdRecentObservationDTO]) async
        -> [eBirdRecentObservation]
    {
        guard let first = dtos.first else { return [] }
        let timeZone =
            await TimeZone.from(latitude: first.lat, longitude: first.lng)
        return dtos.map { .init(dto: $0, timeZone: timeZone) }
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
        subId: "subid",
        timeZone: .current
    )
}

public extension [eBirdRecentObservation] {
    // periphery:ignore - used in #Preview
    static let fake = [eBirdRecentObservation.fake]
}

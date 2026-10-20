// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct eBirdObservation: Sendable {
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
    // public let subnational2Code: String
    // public let subnational2Name: String
    // public let subnational1Code: String
    // public let subnational1Name: String
    // public let countryCode: String
    // public let countryName: String
    // public let userDisplayName: String
    public let obsId: String
    // public let checklistId: String
    // public let presenceNoted: Bool
    // public let hasComments: Bool
    // public let firstName: String
    // public let lastName: String
    // public let hasRichMedia: Bool
    public let timeZone: TimeZone
}

public extension eBirdObservation {
    init(dto: eBirdObservationDTO,
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
        obsId = dto.obsId
        self.timeZone = timeZone
    }
}

public extension [eBirdObservation] {
    static func from(dtos: [eBirdObservationDTO],
                     in timeZone: TimeZone)
        -> [eBirdObservation]
    {
        dtos.map { .init(dto: $0, timeZone: timeZone) }
    }
}

extension eBirdObservation: Identifiable {
    public var id: String { "\(obsId).\(subId)" }
}

extension eBirdObservation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension eBirdObservation {
    init(fake speciesCode: String) {
        self.init(
            speciesCode: speciesCode,
            comName: "f-\(speciesCode)",
            sciName: "Specious Reasoning",
            locId: "L285884",
            locName: "My Backyard",
            obsDt: Date.now,
            howMany: 4,
            lat: 40.7,
            lng: -74.0,

            locationPrivate: false,
            subId: "subid",

            // userDisplayName: "Barack Obama",
            obsId: "obsid",
            // checklistId: "checklistis",

            // hasComments: true,
            // firstName: "Barack",
            // lastName: "Obama",
            // hasRichMedia: false
            timeZone: .current
        )
    }

    static let fake = eBirdObservation(fake: "species")
}

extension eBirdObservation: Encodable {}

public extension [eBirdObservation] {
    // periphery:ignore - used in #Preview
    static let fake = [eBirdObservation.fake]
}

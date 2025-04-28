// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct eBirdObservation: Codable, Sendable {
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
    public let userDisplayName: String
    public let obsId: String
    public let checklistId: String
    // public let presenceNoted: Bool
    public let hasComments: Bool
    public let firstName: String
    public let lastName: String
    public let hasRichMedia: Bool
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
    static let fake = eBirdObservation(
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

        userDisplayName: "Barack Obama",
        obsId: "obsid",
        checklistId: "checklistis",

        hasComments: true,
        firstName: "Barack",
        lastName: "Obama",
        hasRichMedia: false
    )
}

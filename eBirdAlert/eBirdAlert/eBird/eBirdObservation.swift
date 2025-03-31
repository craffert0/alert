// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

struct eBirdObservation: Codable {
    let speciesCode: String
    let comName: String
    let sciName: String
    let locId: String
    let locName: String
    let obsDt: String // "2025-03-30 17:15"
    let howMany: Int
    let lat: Double
    let lng: Double
    let obsValid: Bool
    let obsReviewed: Bool
    let locationPrivate: Bool
    let subId: String
    let subnational2Code: String
    let subnational2Name: String
    let subnational1Code: String
    let subnational1Name: String
    let countryCode: String
    let countryName: String
    let userDisplayName: String
    let obsId: String // ID!
    let checklistId: String
    let presenceNoted: Bool
    let hasComments: Bool
    let firstName: String
    let lastName: String
    let hasRichMedia: Bool
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public struct eBirdRecentObservationDTO: Codable, Sendable {
    public let speciesCode: String
    public let comName: String
    public let sciName: String
    public let locId: String
    public let locName: String
    public let obsDt: String
    public let howMany: Int?
    public let lat: Double
    public let lng: Double
    // public let obsValid: Bool
    // public let obsReviewed: Bool
    public let locationPrivate: Bool
    public let subId: String
}

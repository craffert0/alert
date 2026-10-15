// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public struct eBirdChecklistDTO: Codable, Sendable {
    // public let protocolId: String
    // public let locId: String
    public let durationHrs: Float?
    // public let allObsReported: Bool
    public let comments: String?
    // public let creationDt: String
    // public let lastEditedDt: String?
    public let obsDt: String
    // public let obsTimeValid: Bool
    // public let checklistId: String
    // public let numObservers: Int
    // public let effortDistanceKm: Float
    // public let effortDistanceEnteredUnit: String
    // public let submissionMethodCode: String
    // public let submissionMethodVersion: String
    // public let deleteTrack: Bool
    public let userDisplayName: String
    // public let numSpecies: Int
    // public let submissionMethodVersionDisp: String
    // public let subAux: [SubAux]
    // public let subAuxAi: [SubAuxAi]
    // public let projectIds: []
    public let obs: [Obs]

    public struct Obs: Codable, Sendable {
        public let speciesCode: String
        // public let exoticCategory: String?
        public let comments: String?
        public let obsId: String
        public let howManyStr: String?
        public let mediaCounts: MediaCounts?
    }

    public struct MediaCounts: Codable, Sendable {
        public let V: Int?
        public let P: Int?
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public struct eBirdChecklist: Codable {
    public let projId: String
    public let subId: String
    public let protocolId: String
    public let locId: String
    public let durationHrs: Float
    public let allObsReported: Bool
    public let comments: String
    public let creationDt: Date
    public let lastEditedDt: Date
    public let obsDt: Date
    public let obsTimeValid: Bool
    public let checklistId: String
    public let numObservers: Int
    public let effortDistanceKm: Float
    public let effortDistanceEnteredUnit: String
    public let subnational1Code: String
    public let submissionMethodCode: String
    public let submissionMethodVersion: String
    public let deleteTrack: Bool
    public let userDisplayName: String
    public let numSpecies: Int
    public let submissionMethodVersionDisp: String
    public let subAux: [SubAux]
    public let subAuxAi: [SubAuxAi]
    // public let projectIds: [] // TODO:
    public let obs: [Obs]

    public struct SubAux: Codable {
        public let subId: String
        public let fieldName: String
        public let entryMethodCode: String
        public let auxCode: String
    }

    public struct SubAuxAi: Codable {
        public let subId: String
        public let method: String
        public let aiType: String
        public let source: String
        public let eventId: Int
    }

    public struct Obs: Codable {
        public let speciesCode: String
        public let exoticCategory: String?
        public let howManyAtleast: Int
        public let howManyAtmost: Int
        public let comments: String?
        public let present: Bool
        public let obsId: String
        public let howManyStr: String
    }
}

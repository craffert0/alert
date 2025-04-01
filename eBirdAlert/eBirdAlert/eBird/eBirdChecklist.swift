// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct eBirdChecklist: Codable {
    let projId: String
    let subId: String
    let protocolId: String
    let locId: String
    let durationHrs: Float
    let allObsReported: Bool
    let comments: String
    let creationDt: Date
    let lastEditedDt: Date
    let obsDt: Date
    let obsTimeValid: Bool
    let checklistId: String
    let numObservers: Int
    let effortDistanceKm: Float
    let effortDistanceEnteredUnit: String
    let subnational1Code: String
    let submissionMethodCode: String
    let submissionMethodVersion: String
    let deleteTrack: Bool
    let userDisplayName: String
    let numSpecies: Int
    let submissionMethodVersionDisp: String
    let subAux: [SubAux]
    let subAuxAi: [SubAuxAi]
    // let projectIds: [] // TODO:
    let obs: [Obs]

    struct SubAux: Codable {
        let subId: String
        let fieldName: String
        let entryMethodCode: String
        let auxCode: String
    }

    struct SubAuxAi: Codable {
        let subId: String
        let method: String
        let aiType: String
        let source: String
        let eventId: Int
    }

    struct Obs: Codable {
        let speciesCode: String
        let exoticCategory: String?
        let howManyAtleast: Int
        let howManyAtmost: Int
        let comments: String?
        let present: Bool
        let obsId: String
        let howManyStr: String
    }
}

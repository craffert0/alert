// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension eBirdChecklist {
    static let fake = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        return try! d.decode(eBirdChecklist.self, from: json)
    }()

    private static let json = """
      {
        "projId": "EBIRD",
        "subId": "S289711384",
        "protocolId": "P22",
        "locId": "L1059455",
        "groupId": "G16210556",
        "durationHrs": 0.55,
        "allObsReported": true,
        "creationDt": "2025-12-22 11:47",
        "lastEditedDt": "2025-12-22 12:07",
        "obsDt": "2025-12-22 10:16",
        "obsTimeValid": true,
        "checklistId": "CL23822",
        "numObservers": 2,
        "effortDistanceKm": 0.202,
        "effortDistanceEnteredUnit": "mi",
        "effortAreaEnteredUnit": "ac",
        "subnational1Code": "US-NY",
        "submissionMethodCode": "EBIRD_iOS",
        "submissionMethodVersion": "3.6.4",
        "deleteTrack": false,
        "userDisplayName": "Colin Rafferty",
        "numSpecies": 12,
        "submissionMethodVersionDisp": "3.6.4",
        "subAux": [
          {
            "subId": "S289711384",
            "fieldName": "nocturnal",
            "entryMethodCode": "ebird_nocturnal",
            "auxCode": "0"
          }
        ],
        "subAuxAi": [],
        "projectIds": [],
        "obs": [
          {
            "speciesCode": "cangoo",
            "howManyAtleast": 10,
            "howManyAtmost": 10,
            "present": false,
            "howManyStr": "10",
            "obsId": "OBS3883116521"
          },
          {
            "speciesCode": "mutswa",
            "exoticCategory": "N",
            "howManyAtleast": 5,
            "howManyAtmost": 5,
            "present": false,
            "howManyStr": "5",
            "obsId": "OBS3883116519"
          },
          {
            "speciesCode": "norsho",
            "howManyAtleast": 30,
            "howManyAtmost": 30,
            "present": false,
            "howManyStr": "30",
            "obsId": "OBS3883116528"
          },
          {
            "speciesCode": "mallar3",
            "howManyAtleast": 25,
            "howManyAtmost": 25,
            "present": false,
            "howManyStr": "25",
            "obsId": "OBS3883116523"
          },
          {
            "speciesCode": "commer",
            "howManyAtleast": 2,
            "howManyAtmost": 2,
            "comments": "I spotted this pair on the lake while searching for the Thayer's Gull.   They were off the Wellhouse shore but I was at begging beach.   Juan Salas was there to help confirm ID with use of his photos, (thank you Juan). A pair of adult female common mergansers.  Sharp, clean break of brown head and body, white under the chin. Unfortunately, only got 2 not-great pics before they flew off heading west towards Green-wood Cemetery.  Will post.",
            "mediaCounts": {
              "P": 2
            },
            "present": false,
            "howManyStr": "2",
            "obsId": "OBS3883116527"
          },
          {
            "speciesCode": "y00475",
            "howManyAtleast": 2,
            "howManyAtmost": 2,
            "present": false,
            "howManyStr": "2",
            "obsId": "OBS3883116518"
          },
          {
            "speciesCode": "ribgul",
            "howManyAtleast": 60,
            "howManyAtmost": 60,
            "present": false,
            "howManyStr": "60",
            "obsId": "OBS3883116524"
          },
          {
            "speciesCode": "amhgul1",
            "howManyAtleast": 50,
            "howManyAtmost": 50,
            "present": false,
            "howManyStr": "50",
            "obsId": "OBS3883116517"
          },
          {
            "speciesCode": "dowwoo",
            "howManyAtleast": 1,
            "howManyAtmost": 1,
            "present": false,
            "howManyStr": "1",
            "obsId": "OBS3883116526"
          },
          {
            "speciesCode": "amecro",
            "howManyAtleast": 2,
            "howManyAtmost": 2,
            "present": false,
            "howManyStr": "2",
            "obsId": "OBS3883116525"
          },
          {
            "speciesCode": "eursta",
            "exoticCategory": "N",
            "howManyAtleast": 2,
            "howManyAtmost": 2,
            "present": false,
            "howManyStr": "2",
            "obsId": "OBS3883116520"
          },
          {
            "speciesCode": "swaspa",
            "howManyAtleast": 1,
            "howManyAtmost": 1,
            "comments": "In the phrags by the wooden shelter at begging beach.",
            "present": false,
            "howManyStr": "1",
            "obsId": "OBS3883116522"
          }
        ]
      }
    """.data(using: .utf8)!
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

let validStatus = 200 ... 299

extension URLSession: @retroactive eBirdService {
    public func getNotable(in range: RangeType,
                           back daysBack: Int) async throws
        -> [Schema.eBirdObservation]
    {
        try await object(for: range.notableRequest(back: daysBack))
    }

    public func getAll(in range: RangeType,
                       back daysBack: Int) async throws
        -> [Schema.eBirdRecentObservation]
    {
        try await object(for: range.allRequest(back: daysBack))
    }

    public func getBird(in range: RangeType,
                        back daysBack: Int,
                        for speciesCode: String) async throws
        -> [eBirdRecentObservation]
    {
        try await object(for: range.birdRequest(back: daysBack,
                                                for: speciesCode))
    }

    public func getChecklist(subId: String) async throws -> eBirdChecklist {
        let request = URLRequest(
            eBirdPath: "product/checklist/view/" + subId
        )
        return try await object(for: request)
    }
}

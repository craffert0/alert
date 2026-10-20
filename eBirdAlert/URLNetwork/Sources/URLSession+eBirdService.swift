// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension URLSession: @retroactive eBirdService {
    public func getNotable(in range: RangeType,
                           back daysBack: Int) async throws
        -> [Schema.eBirdObservation]
    {
        try await .from(
            dtos: object(for: range.notableRequest(back: daysBack)),
            in: range.timeZone
        )
    }

    public func getAll(in range: RangeType,
                       back daysBack: Int) async throws
        -> [Schema.eBirdRecentObservation]
    {
        try await .from(
            dtos: object(for: range.allRequest(back: daysBack)),
            in: range.timeZone
        )
    }

    public func getBird(in range: RangeType,
                        back daysBack: Int,
                        for speciesCode: String) async throws
        -> [eBirdRecentObservation]
    {
        try await .from(
            dtos: object(for: range.birdRequest(back: daysBack,
                                                for: speciesCode)),
            in: range.timeZone
        )
    }

    public func getChecklist(subId: String,
                             timeZone: TimeZone) async throws -> eBirdChecklist
    {
        let request = URLRequest(
            eBirdPath: "product/checklist/view/" + subId
        )
        return try await .init(dto: object(for: request), timeZone: timeZone)
    }
}

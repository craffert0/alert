// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

public nonisolated struct RemoteService: eBirdService {
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    @concurrent
    public func getNotable(in range: RangeType,
                           back daysBack: Int) async throws
        -> [Schema.eBirdObservation]
    {
        try await .from(
            dtos: session.object(for: range.notableRequest(back: daysBack)),
            in: range.timeZone
        )
    }

    @concurrent
    public func getAll(in range: RangeType,
                       back daysBack: Int) async throws
        -> [Schema.eBirdRecentObservation]
    {
        try await .from(
            dtos: session.object(for: range.allRequest(back: daysBack)),
            in: range.timeZone
        )
    }

    @concurrent
    public func getBird(in range: RangeType,
                        back daysBack: Int,
                        for speciesCode: String) async throws
        -> [eBirdRecentObservation]
    {
        try await .from(
            dtos: session.object(for: range.birdRequest(back: daysBack,
                                                        for: speciesCode)),
            in: range.timeZone
        )
    }

    @concurrent
    public func getChecklist(subId: String,
                             timeZone: TimeZone) async throws -> eBirdChecklist
    {
        let request = URLRequest(
            eBirdPath: "product/checklist/view/" + subId
        )
        return try await .init(dto: session.object(for: request),
                               timeZone: timeZone)
    }
}

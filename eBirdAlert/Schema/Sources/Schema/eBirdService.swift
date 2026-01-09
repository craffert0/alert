// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public protocol eBirdService: Sendable {
    func getNotable(in range: RangeType,
                    back daysBack: Int) async throws -> [eBirdObservation]
    func getAll(in range: RangeType,
                back daysBack: Int) async throws -> [eBirdRecentObservation]
    func getBird(in range: RangeType,
                 back daysBack: Int,
                 for speciesCode: String) async throws -> [eBirdRecentObservation]

    func getChecklist(subId: String) async throws -> eBirdChecklist
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public protocol eBirdService {
    func getNotable(in range: RangeType) async throws -> [eBirdObservation]
    func getAll(in range: RangeType) async throws -> [eBirdRecentObservation]
    func getBird(in range: RangeType,
                 for speciesCode: String) async throws -> [eBirdRecentObservation]

    func getChecklist(subId: String) async throws -> eBirdChecklist
}

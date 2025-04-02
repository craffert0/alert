// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public protocol eBirdService {
    func getNearbyNotable() async throws -> [eBirdObservation]

    func getChecklist(subId: String) async throws -> eBirdChecklist
}

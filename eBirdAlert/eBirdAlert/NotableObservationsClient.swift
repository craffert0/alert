// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

struct NotableObservationsClient {
    var observations: [eBirdObservation] {
        get async throws {
            print("refresh!")
            // TODO:
            return []
        }
    }
}

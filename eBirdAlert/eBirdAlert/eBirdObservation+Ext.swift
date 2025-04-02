// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

extension eBirdObservation: @retroactive Identifiable {
    public var id: String { "\(obsId).\(subId)" }
}

extension eBirdObservation: Species {}

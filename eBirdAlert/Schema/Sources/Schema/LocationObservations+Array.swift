// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public extension [LocationObservations] {
    var total_count: Int { reduce(0) { $0 + $1.observations.count } }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema

extension eBirdRegionInfo: Equatable {
    public static func == (lhs: eBirdRegionInfo, rhs: eBirdRegionInfo)
        -> Bool
    {
        lhs.code == rhs.code
    }
}

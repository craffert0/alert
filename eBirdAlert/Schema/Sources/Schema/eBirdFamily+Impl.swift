// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

extension eBirdFamily: Decodable {}

extension eBirdFamily: Comparable {
    public static func < (lhs: eBirdFamily, rhs: eBirdFamily) -> Bool {
        lhs.sortKey < rhs.sortKey
    }
}

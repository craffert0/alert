// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

extension eBirdOrder: Decodable {}

extension eBirdOrder: Comparable {
    public static func < (lhs: eBirdOrder, rhs: eBirdOrder) -> Bool {
        lhs.sortKey < rhs.sortKey
    }
}

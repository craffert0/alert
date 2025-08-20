// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public extension RandomAccessCollection {
    func lowerBound(where cond: (Self.Element) throws -> Bool) rethrows
        -> Self.Index
    {
        var it = startIndex
        var remaining = count
        while remaining > 0 {
            let step = remaining / 2
            let mid = index(it, offsetBy: step)
            if try cond(self[mid]) {
                it = index(it, offsetBy: step + 1)
                remaining -= (step + 1)
            } else {
                remaining = step
            }
        }
        return it
    }
}

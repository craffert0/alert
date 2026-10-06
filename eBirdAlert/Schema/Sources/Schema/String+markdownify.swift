// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

extension String {
    private mutating func href() {
        let re = /<a href="([^"]+)">(.+?)<\/a>/
        while let m = firstMatch(of: re) {
            replaceSubrange(m.range, with: "[\(m.2)](\(m.1))")
        }
    }

    var markdownify: String? {
        var result = self
        result.href()
        if result == self {
            return nil
        } else {
            return result
        }
    }
}

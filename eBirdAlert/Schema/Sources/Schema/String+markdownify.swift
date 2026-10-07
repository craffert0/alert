// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public extension String {
    nonisolated(unsafe) static var markdownProtocol: StringMarkdownProtocol?

    var markdownify: String? {
        var result = self
        result.href()
        result.latlng()
        result.unicodes()
        if result == self {
            return nil
        } else {
            return result
        }
    }

    private mutating func href() {
        for m in matches(of: /<a href="([^"]+)">(.+?)<\/a>/).reversed() {
            replaceSubrange(m.range, with: "[\(m.2)](\(m.1))")
        }
    }

    private mutating func latlng() {
        guard let mdp = Self.markdownProtocol else { return }
        for m in matches(of: /(-?\d+\.\d+), *(-?\d+\.\d+)/).reversed() {
            replaceSubrange(
                m.range,
                with: "[\(m.0)](\(mdp.link(lat: m.1, lng: m.2)))"
            )
        }
    }

    private mutating func unicodes() {
        for m in matches(of: /&#x([0-9a-f]+);/).reversed() {
            if let ui32 = UInt32(m.1, radix: 16),
               let us = UnicodeScalar(ui32)
            {
                replaceSubrange(m.range, with: "\(us)")
            }
        }
    }
}

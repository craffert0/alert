// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

extension String {
    private static let kTokenLetters =
        "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRTUVWXYZ2346789"

    static func random(size: Int) -> String {
        (0 ..< size).map {
            _ in String(kTokenLetters.randomElement()!)
        }.joined()
    }
}

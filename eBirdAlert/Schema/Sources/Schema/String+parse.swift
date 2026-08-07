// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

extension String {
    mutating func parseString() throws -> String {
        guard removeFirst() == "\"",
              let end = firstIndex(of: "\"")
        else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [], debugDescription: self)
            )
        }
        let result = prefix(upTo: end)
        removeSubrange(startIndex ... end)
        if !isEmpty {
            removeFirst()
        }
        return String(result)
    }

    mutating func parseDouble() throws -> Double {
        guard let end = firstIndex(of: ","),
              let result = Double(prefix(upTo: end))
        else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [], debugDescription: self)
            )
        }
        removeSubrange(startIndex ... end)
        return result
    }
}

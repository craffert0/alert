// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation

private extension String {
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

private extension eBirdRegionInfo.Bounds {
    static func from(minX: Double, maxX: Double,
                     minY: Double, maxY: Double) -> eBirdRegionInfo.Bounds?
    {
        guard minX != 0.0 || maxX != 0.0 || minY != 0.0 || maxY != 0.0
        else { return nil }
        return eBirdRegionInfo.Bounds(minX: minX, maxX: maxX,
                                      minY: minY, maxY: maxY)
    }
}

private struct Parser {
    init(_ line: String) throws {
        guard line == "code,result,latitude,longitude,type,bounds_minX,bounds_maxX,bounds_minY,bounds_maxY,subregions"
        else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [], debugDescription: line)
            )
        }
    }

    func parse(_ input: String) throws -> eBirdRegionInfo {
        var I = input
        let code = try I.parseString()
        let result = try I.parseString()
        let latitude = try I.parseDouble()
        let longitude = try I.parseDouble()
        let type = try eBirdRegionType(rawValue: I.parseString())!
        let bounds_minX = try I.parseDouble()
        let bounds_maxX = try I.parseDouble()
        let bounds_minY = try I.parseDouble()
        let bounds_maxY = try I.parseDouble()
        let subregionCodes =
            try I.parseString().split(separator: ",").map { String($0) }

        return .init(
            bounds: .from(minX: bounds_minX,
                          maxX: bounds_maxX,
                          minY: bounds_minY,
                          maxY: bounds_maxY),
            result: result,
            code: code,
            type: type,
            longitude: longitude,
            latitude: latitude,
            subregionCodes: subregionCodes.isEmpty ? nil : subregionCodes
        )
    }
}

public extension Array {
    static func fromCSV(_ url: URL) async throws -> [eBirdRegionInfo] {
        var result: [eBirdRegionInfo] = []
        var parser: Parser?
        for try await line in url.lines {
            if let parser {
                try result.append(parser.parse(line))
            } else {
                try parser = Parser(line)
            }
        }
        return result
    }
}

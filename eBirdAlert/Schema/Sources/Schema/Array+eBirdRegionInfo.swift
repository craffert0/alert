// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import SwiftUtil

public extension [eBirdRegionInfo] {
    /// Assuming we're sorted by code, look it up.
    func getInfo(for regionCode: any StringProtocol) -> eBirdRegionInfo? {
        let it = lowerBound(of: regionCode, comp: { $0.code < $1 })
        guard it != endIndex, self[it].code == regionCode else {
            return nil
        }
        return self[it]
    }
}

public extension [eBirdRegionInfo] {
    /// Load up a new array froma CSV file.
    static func fromCSV(_ url: URL) throws -> [eBirdRegionInfo] {
        var lines = try String(data: Data(contentsOf: url), encoding: .utf8)!
            .split(separator: "\n")
        var parser = try Parser(String(lines.removeFirst()))
        for line in lines {
            try parser.parse(line)
        }
        return parser.regions
    }
}

private struct Parser {
    var regions: [eBirdRegionInfo] = []

    init(_ line: String) throws {
        guard line == "code,result,latitude,longitude,type,bounds_minX,bounds_maxX,bounds_minY,bounds_maxY,subregions"
        else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [], debugDescription: line)
            )
        }
    }

    mutating func parse(_ input: any StringProtocol) throws {
        var I = String(input)
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

        regions.append(.init(
            bounds: .from(minX: bounds_minX,
                          maxX: bounds_maxX,
                          minY: bounds_minY,
                          maxY: bounds_maxY),
            result: result,
            code: code,
            type: type,
            longitude: longitude,
            latitude: latitude,
            subregionCodes: subregionCodes.isEmpty ? nil : subregionCodes,
            parent: regions.getParent(for: code)
        ))
    }
}

private extension eBirdRegionInfo.Bounds {
    /// nil if it's all zeros
    static func from(minX: Double, maxX: Double,
                     minY: Double, maxY: Double) -> eBirdRegionInfo.Bounds?
    {
        guard minX != 0.0 || maxX != 0.0 || minY != 0.0 || maxY != 0.0
        else { return nil }
        return eBirdRegionInfo.Bounds(minX: minX, maxX: maxX,
                                      minY: minY, maxY: maxY)
    }
}

private extension [eBirdRegionInfo] {
    func getParent(for regionCode: String) -> eBirdRegionInfo? {
        guard let i = regionCode.lastIndex(of: "-") else { return nil }
        let parentCode =
            regionCode.prefix(through: regionCode.index(before: i))
        return getInfo(for: parentCode)
    }
}

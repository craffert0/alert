// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

private struct Parser {
    init(_ line: String) throws {
        guard line == "speciesCode,comName,taxonOrder,familyCode"
        else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [], debugDescription: line)
            )
        }
    }

    func parse(_ input: String) throws -> Taxon {
        var I = input
        let speciesCode = try I.parseString()
        let comName = try I.parseString()
        let taxonOrder = try I.parseDouble()
        let familyCode = try eBirdFamily(rawValue: I.parseString())!

        return .init(
            comName: comName,
            speciesCode: speciesCode,
            taxonOrder: taxonOrder,
            familyCode: familyCode
        )
    }
}

public extension [Taxon] {
    static func from(_ url: URL) throws -> [Element] {
        try JSONDecoder().decode([Element].self,
                                 from: Data(contentsOf: url))
    }

    static func fromCSV(_ url: URL) throws -> [Taxon] {
        var lines = try String(data: Data(contentsOf: url), encoding: .utf8)!.split(separator: "\n")
        let parser = try Parser(String(lines.removeFirst()))

        return try lines.map { try parser.parse(String($0)) }
    }
}

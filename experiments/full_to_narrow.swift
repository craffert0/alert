#! /usr/bin/swift

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct Taxon: Codable {
    let comName: String
    let speciesCode: String
}

let encoder = JSONEncoder()
encoder.outputFormatting = [.withoutEscapingSlashes]
try print(String(data: encoder.encode(
        JSONDecoder().decode([Taxon].self,
                             from: FileManager.default.contents(
                                 atPath: CommandLine.arguments[1])!)
            .sorted(by: { $0.speciesCode < $1.speciesCode })),
    encoding: .utf8)!)

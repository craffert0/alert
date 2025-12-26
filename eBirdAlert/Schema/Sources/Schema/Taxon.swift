// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public struct Taxon: Decodable {
    public let comName: String
    public let speciesCode: String
    public let taxonOrder: Double
    public let order: String

    public func contains(string: String) -> Bool {
        comName.range(of: string) != nil
    }
}

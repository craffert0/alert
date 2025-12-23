// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

struct Taxon: Decodable {
    let comName: String
    let speciesCode: String
    let taxonOrder: Double

    func contains(string: String) -> Bool {
        comName.range(of: string) != nil
    }
}

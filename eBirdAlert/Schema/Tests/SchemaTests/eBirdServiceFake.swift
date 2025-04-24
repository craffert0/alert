// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Foundation
import Schema

class eBirdServiceFake {
    let notableName: String?
    let allName: String?

    init(notableName: String? = nil,
         allName: String? = nil)
    {
        self.notableName = notableName
        self.allName = allName
    }

    private func get<Output: Decodable>(name: String) throws -> Output {
        guard let path = Bundle.module.url(forResource: name,
                                           withExtension: "json")
        else {
            throw eBirdServiceFakeError.badName(name: name)
        }
        let json = try Data(contentsOf: path)
        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        return try d.decode(Output.self, from: json)
    }
}

extension eBirdServiceFake: eBirdService {
    func getNotable(near _: CLLocation) async throws -> [eBirdObservation] {
        guard let notableName else { throw eBirdServiceFakeError.noName }
        return try get(name: notableName)
    }

    func getAll(near _: CLLocation) async throws -> [eBirdObservation] {
        guard let allName else { throw eBirdServiceFakeError.noName }
        return try get(name: allName)
    }

    func getChecklist(subId: String) async throws -> eBirdChecklist {
        try get(name: subId)
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension URLSession: @retroactive CensusService {
    private struct CensusAreaResult: Decodable {
        let results: [CensusTract]
    }

    public func getCensusTract(for coord: Coordinate) async throws
        -> CensusTract
    {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: "\(coord.latitude)"),
            URLQueryItem(name: "lon", value: "\(coord.longitude)"),
        ]
        let url = URL(string: "https://geo.fcc.gov/api/census/area")!
            .appending(queryItems: queryItems)
        let request = URLRequest(url: url)
        let model: CensusAreaResult = try await object(for: request)
        guard let tract = model.results.first else {
            throw eBirdServiceError.noTract
        }
        return tract
    }
}

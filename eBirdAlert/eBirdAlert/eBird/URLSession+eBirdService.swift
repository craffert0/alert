// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

let validStatus = 200 ... 299

extension URLSession: Sendable {
    func get<Output: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = [],
        withLocation: Bool = false
    ) async throws -> Output {
        let applicationKey = PreferencesModel.global.applicationKey
        guard applicationKey != "" else { throw eBirdServiceError.noKey }

        var allQueryItems =
            queryItems + [URLQueryItem(name: "fmt", value: "json")]
        if withLocation {
            guard let location = LocationService.global.location else {
                throw eBirdServiceError.noLocation
            }
            allQueryItems += [
                URLQueryItem(name: "lat",
                             value: "\(location.coordinate.latitude)"),
                URLQueryItem(name: "lng",
                             value: "\(location.coordinate.longitude)"),
            ]
        }

        let url = URL(string: "https://api.ebird.org/v2/" + path)!
            .appending(queryItems: allQueryItems)

        var request = URLRequest(url: url)
        request.setValue(applicationKey,
                         forHTTPHeaderField: "x-ebirdapitoken")

        guard let (data, response) = try await self.data(for: request)
            as? (Data, HTTPURLResponse),
            validStatus.contains(response.statusCode)
        else {
            throw eBirdServiceError.networkError
        }

        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        return try d.decode(Output.self, from: data)
    }

    func getNearbyNotable(back: Int = 2, distKM: Int = 50,
                          hotspot: Bool = false, max: Int? = nil)
        async throws -> [eBirdObservation]
    {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "detail", value: "full"),
            URLQueryItem(name: "back", value: "\(back)"),
            URLQueryItem(name: "dist", value: "\(distKM)"),
            URLQueryItem(name: "hotspot",
                         value: hotspot ? "true" : "false"),
        ]
        if let max {
            queryItems += [URLQueryItem(name: "max", value: "\(max)")]
        }

        return try await get(path: "data/obs/geo/recent/notable",
                             queryItems: queryItems,
                             withLocation: true)
    }

    func getChecklist(subId: String) async throws -> eBirdChecklist {
        try await get(path: "product/checklist/view/" + subId)
    }
}

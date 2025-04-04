// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

let validStatus = 200 ... 299

extension URLSession: Sendable, @retroactive eBirdService {
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

    public func getNearbyNotable() async throws -> [Schema.eBirdObservation] {
        let prefs = PreferencesModel.global

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "detail", value: "full"),
            URLQueryItem(name: "hotspot", value: "false"),
            URLQueryItem(name: "back", value: "\(prefs.daysBack)"),
            URLQueryItem(name: "dist", value: "\(Double(prefs.distMiles) * 1.62)"),
        ]
        print(queryItems)

        return try await get(path: "data/obs/geo/recent/notable",
                             queryItems: queryItems,
                             withLocation: true)
    }

    public func getChecklist(subId: String) async throws -> eBirdChecklist {
        try await get(path: "product/checklist/view/" + subId)
    }
}

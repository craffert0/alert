// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

let validStatus = 200 ... 299

extension URLSession: Sendable {
    // data/obs/geo/recent/notable
    func getNearbyNotable(back: Int = 2, distKM: Int = 50,
                          hotspot: Bool = false, max: Int? = nil)
        async throws -> [eBirdObservation]
    {
        let applicationKey = PreferencesModel.global.applicationKey
        guard applicationKey != "" else { throw eBirdServiceError.noKey }
        guard let location = LocationService.global.location else {
            throw eBirdServiceError.noLocation
        }

        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "fmt", value: "json"))
        queryItems.append(URLQueryItem(name: "detail", value: "full"))
        queryItems.append(URLQueryItem(name: "lat",
                                       value: "\(location.coordinate.latitude)"))
        queryItems.append(URLQueryItem(name: "lng",
                                       value: "\(location.coordinate.longitude)"))
        queryItems.append(URLQueryItem(name: "back", value: "\(back)"))
        queryItems.append(URLQueryItem(name: "dist", value: "\(distKM)"))
        queryItems.append(URLQueryItem(name: "hotspot",
                                       value: hotspot ? "true" : "false"))
        if let max {
            queryItems.append(URLQueryItem(name: "max",
                                           value: "\(max)"))
        }
        let url =
            URL(string: "https://api.ebird.org/v2/data/obs/geo/recent/notable")!
                .appending(queryItems: queryItems)
        var request = URLRequest(url: url)
        request.setValue(applicationKey, forHTTPHeaderField: "x-ebirdapitoken")
        guard let (data, response) = try await self.data(for: request) as? (Data, HTTPURLResponse),
              validStatus.contains(response.statusCode)
        else {
            throw eBirdServiceError.networkError
        }
        let result = try JSONDecoder().decode([eBirdObservation].self, from: data)
        return result
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension URLRequest {
    init(eBirdPath path: String,
         queryItems: [URLQueryItem] = [],
         withLocation: Bool = false) throws
    {
        let applicationKey = try KeychainService.global.applicationKey

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

        self.init(url: url)
        setValue(applicationKey,
                 forHTTPHeaderField: "x-ebirdapitoken")
    }
}

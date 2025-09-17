// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Foundation
import Schema

let validStatus = 200 ... 299

extension URLSession: @retroactive eBirdService {
    func object<Output: Decodable>(
        for request: URLRequest
    ) async throws -> Output {
        guard let (data, response) = try await self.data(for: request)
            as? (Data, HTTPURLResponse)
        else {
            throw eBirdServiceError.networkError
        }

        guard validStatus.contains(response.statusCode) else {
            // Normally 403 on error
            throw eBirdServiceError.httpError(statusCode: response.statusCode)
        }

        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        return try d.decode(Output.self, from: data)
    }

    public func getNotable(near location: CLLocation) async throws
        -> [Schema.eBirdObservation]
    {
        let request = try URLRequest(
            eBirdPath: "data/obs/geo/recent/notable",
            queryItems: PreferencesModel.global.geoQueryItems,
            withLocation: location
        )
        return try await object(for: request)
    }

    public func getAll(near location: CLLocation) async throws
        -> [Schema.eBirdObservation]
    {
        let request = try URLRequest(
            eBirdPath: "data/obs/geo/recent",
            queryItems: PreferencesModel.global.geoQueryItems,
            withLocation: location
        )
        return try await object(for: request)
    }

    public func getChecklist(subId: String) async throws -> eBirdChecklist {
        let request = try URLRequest(
            eBirdPath: "product/checklist/view/" + subId
        )
        return try await object(for: request)
    }
}

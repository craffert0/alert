// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import CoreLocation
import Foundation
import Schema

let validStatus = 200 ... 299

extension URLSession: @retroactive eBirdService {
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

    public func getNotable(in region: RegionCodeProvider) async throws
        -> [Schema.eBirdObservation]
    {
        let request = try URLRequest(
            eBirdPath: "data/obs/\(region.code)/recent/notable",
            queryItems: PreferencesModel.global.geoQueryItems
        )
        return try await object(for: request)
    }

    public func getAll(near location: CLLocation) async throws
        -> [Schema.eBirdRecentObservation]
    {
        let request = try URLRequest(
            eBirdPath: "data/obs/geo/recent",
            queryItems: PreferencesModel.global.geoQueryItems,
            withLocation: location
        )
        return try await object(for: request)
    }

    public func getAll(in region: RegionCodeProvider) async throws
        -> [Schema.eBirdRecentObservation]
    {
        let request = try URLRequest(
            eBirdPath: "data/obs/\(region.code)/recent",
            queryItems: PreferencesModel.global.geoQueryItems
        )
        return try await object(for: request)
    }

    public func getBird(near location: CLLocation,
                        for speciesCode: String) async throws
        -> [Schema.eBirdRecentObservation]
    {
        let request = try URLRequest(
            eBirdPath: "data/obs/geo/recent/\(speciesCode)",
            queryItems: PreferencesModel.global.geoQueryItems,
            withLocation: location
        )
        return try await object(for: request)
    }

    public func getBird(in region: RegionCodeProvider,
                        for speciesCode: String) async throws
        -> [Schema.eBirdRecentObservation]
    {
        let request = try URLRequest(
            eBirdPath: "data/obs/\(region.code)/recent/\(speciesCode)",
            queryItems: PreferencesModel.global.geoQueryItems
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

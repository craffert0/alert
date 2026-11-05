// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import URLNetwork

actor FixedRegionService: eBirdRegionService {
    static let global = FixedRegionService()

    private var loader: FixedRegionLoader?
    private var fetchTask: Task<FixedRegionLoader, Error>?

    func getSubRegions(of region: RegionCodeProvider,
                       as _: eBirdRegionType) async -> [eBirdRegion]
    {
        try! await getLoader().getSubRegions(of: region)
    }

    func getInfo(for regionCode: String) async -> eBirdRegionInfo? {
        try! await getLoader().getInfo(for: regionCode)
    }

    private func getLoader() async throws -> FixedRegionLoader {
        if let loader {
            return loader
        }

        if let fetchTask {
            return try await fetchTask.value
        }

        let task = Task {
            let url = Bundle.main.url(forResource: "regions",
                                      withExtension: "csv")!
            return try FixedRegionLoader(infos: .fromCSV(url))
        }
        fetchTask = task
        defer { fetchTask = nil }

        let newLoader = try await task.value
        loader = newLoader
        return newLoader
    }
}

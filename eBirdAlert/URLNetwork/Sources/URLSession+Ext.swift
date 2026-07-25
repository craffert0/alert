// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

private let kMinSleep: Duration = .milliseconds(500)
private let kMaxSleep: Duration = .seconds(8)

extension URLSession {
    func object<Output: Decodable>(
        for request: URLRequest
    ) async throws -> Output {
        var nextSleep = kMinSleep
        while true {
            guard let (data, response) = try await self.data(for: request)
                as? (Data, HTTPURLResponse)
            else {
                throw eBirdServiceError.networkError
            }

            if (200 ... 299).contains(response.statusCode) {
                return try object(from: data)
            } else if response.statusCode == 429, nextSleep <= kMaxSleep {
                try await Task.sleep(for: nextSleep)
                nextSleep = nextSleep * 2
            } else {
                throw eBirdServiceError.httpError(statusCode: response.statusCode)
            }
        }
    }

    func object<Output: Decodable>(from data: Data) throws -> Output {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        return try d.decode(Output.self, from: data)
    }
}

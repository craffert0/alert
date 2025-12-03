// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension URLSession {
    static let region = URLSession(configuration: .region)

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

        if self == .region {
            configuration.urlCache?.storeCachedResponse(
                CachedURLResponse(response: response, data: data),
                for: request
            )
        }

        return try object(from: data)
    }

    func object<Output: Decodable>(from data: Data) throws -> Output {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        return try d.decode(Output.self, from: data)
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum eBirdServiceError: Error {
    case noKey
    case noLocation
    case networkError
    case httpError(statusCode: Int)
    case urlError(error: URLError)
    case unexpectedError(error: Error)
    case expandedArea(distance: Double, units: DistanceUnits)

    static func from(_ error: Error?) -> eBirdServiceError? {
        guard let error else { return nil }
        if let urlError = error as? URLError {
            return .urlError(error: urlError)
        }
        if let ebirdError = error as? eBirdServiceError {
            return ebirdError
        }
        return .unexpectedError(error: error)
    }
}

extension eBirdServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noKey: "no api key"
        case .noLocation: "could not get location"
        case .networkError: "network error?"
        case let .httpError(statusCode):
            HTTPURLResponse.localizedString(forStatusCode: statusCode)
        case .urlError: "bad network connection"
        case let .unexpectedError(e): "unexpected: \(e)"
        case .expandedArea: "Expanded Area"
        }
    }
}

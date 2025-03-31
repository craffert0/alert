// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum eBirdServiceError: Error {
    case noKey
    case noLocation
    case networkError
    case unauthorized
    case unexpectedError(error: Error)
}

extension eBirdServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noKey: "no api key"
        case .noLocation: "could not get location"
        case .networkError: "network error?"
        case .unauthorized: "you not authorized"
        case let .unexpectedError(e): "unexpected: \(e)"
        }
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum eBirdServiceError: Error, LocalizedError {
    case noKey
    case unauthorized
    case unexpectedError(error: Error)
}

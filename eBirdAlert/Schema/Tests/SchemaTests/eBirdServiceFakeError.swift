// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum eBirdServiceFakeError: Error {
    case noName
    case badName(name: String)
}

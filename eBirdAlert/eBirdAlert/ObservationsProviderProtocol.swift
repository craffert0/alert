// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

protocol ObservationsProviderProtocol {
    var isEmpty: Bool { get }
    func load() async throws
    func refresh() async throws
}

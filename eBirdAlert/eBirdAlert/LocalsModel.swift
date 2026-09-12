// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema
import URLNetwork

@Observable
class LocalsModel {
    var provider: RecentObservationsProvider
    var error: eBirdServiceError?
    var showError = false
    var isLoading = false

    init(provider: RecentObservationsProvider) {
        self.provider = provider
    }

    func load() async {
        print("load!")
    }
}

extension LocalsModel: LoadableModel {}

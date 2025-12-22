// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BackgroundTasks

extension BGAppRefreshTaskRequest {
    convenience init(id: PermittedIdentifier) {
        self.init(identifier: id.rawValue)
    }
}

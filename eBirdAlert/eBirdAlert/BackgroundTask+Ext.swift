// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

extension BackgroundTask {
    static func appRefresh(id: PermittedIdentifier)
        -> BackgroundTask<Void, Void>
    {
        BackgroundTask.appRefresh(id.rawValue)
    }
}

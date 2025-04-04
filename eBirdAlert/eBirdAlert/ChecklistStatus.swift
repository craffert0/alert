// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

enum ChecklistStatus: Codable {
    case unloaded
    case loading(startTime: Date)
    case value(checklist: eBirdChecklist)
    case error(reason: String)
}

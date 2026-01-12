// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation

enum NotificationType {
    case none
    case local
    case server(String, Data)
}

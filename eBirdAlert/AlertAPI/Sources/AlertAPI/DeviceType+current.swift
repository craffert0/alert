// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public extension Components.Schemas.DeviceType {
    #if DEBUG
        static let current = Components.Schemas.DeviceType.development
    #else
        static let current = Components.Schemas.DeviceType.production
    #endif
}

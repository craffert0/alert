// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI

extension User {
    var response: Components.Schemas.User {
        .init(id: id!.uuidString,
              name: name,
              token: token)
    }
}

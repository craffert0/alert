// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI

extension User {
    convenience init(from request: Components.Schemas.NewUserRequest) {
        self.init()
        name = request.name
        token = String.random(size: 12)
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public extension String {
    var encoded: String? {
        addingPercentEncoding(
            withAllowedCharacters: .urlQueryParamAndKeyAllowed
        )
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema

struct PreferencesStringMarkdown: StringMarkdownProtocol {
    func link(lat: any StringProtocol, lng: any StringProtocol) -> String {
        PreferencesModel.global.mapURL(lat: lat, lng: lng)
    }
}

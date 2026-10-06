// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public protocol StringMarkdownProtocol {
    func link(lat: any StringProtocol, lng: any StringProtocol) -> String
}

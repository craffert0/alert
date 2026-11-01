// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import URLNetwork

let eBirdServiceGlobal: eBirdService =
    RemoteService(session: URLSession.shared)

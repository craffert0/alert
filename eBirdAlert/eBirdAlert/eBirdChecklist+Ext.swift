// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

extension eBirdChecklist.Obs: @retroactive Identifiable {
    public var id: String { obsId }
}

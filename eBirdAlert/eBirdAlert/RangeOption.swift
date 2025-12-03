// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum RangeOption: String {
    case radius
    case region
}

extension RangeOption: CaseIterable, Identifiable {
    var id: Self { self }
}

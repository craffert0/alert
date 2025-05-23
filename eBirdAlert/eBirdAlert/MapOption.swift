// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum MapOption: String {
    case apple
    case google
}

extension MapOption: CaseIterable, Identifiable {
    var id: Self { self }
}

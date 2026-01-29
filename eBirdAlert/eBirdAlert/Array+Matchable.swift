// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

extension Array where Element: Matchable {
    func restrict(by searchText: String) -> [Element] {
        let tokens = searchText.lowercased().split(separator: " ")
        return compactMap { m in
            tokens.allSatisfy {
                m.matchText.lowercased().contains($0)
            } ? m : nil
        }
    }
}

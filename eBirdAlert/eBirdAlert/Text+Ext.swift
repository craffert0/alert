// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

extension Text {
    init(_ date: Date, relativeTo source: TimeDataSource<Date>) {
        self.init(source, format: DateFormatStyleRelative(to: date))
    }
}

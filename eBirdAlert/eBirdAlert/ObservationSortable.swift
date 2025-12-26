// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

protocol ObservationSortable {
    var comName: String { get }
    var obsDt: Date { get }
    var taxonOrder: Double { get }
    var order: String { get }
}

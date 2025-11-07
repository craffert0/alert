// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

protocol eBirdObservationProtocol: LocationProtocol {
    var speciesCode: String { get }
    var comName: String { get }
    var obsDt: Date { get }
    var howMany: Int? { get }
}

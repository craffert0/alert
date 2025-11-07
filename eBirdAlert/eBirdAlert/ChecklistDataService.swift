// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Observation
import Schema

protocol ChecklistDataServiceObservation {
    var subId: String { get }
    var obsDt: Date { get }
}

protocol ChecklistDataService: Observable {
    @MainActor
    func prepare(obs: ChecklistDataServiceObservation)

    @MainActor
    func load(obs: ChecklistDataServiceObservation) -> Checklist
}

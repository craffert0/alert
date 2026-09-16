// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Observation
import Schema

@Observable
class RangePreferenceSlice {
    var rangeOption: RangeOption
    var distValue: Double
    var distUnits: DistanceUnits
    var regionCode: String?

    init(from model: PreferencesModel) {
        rangeOption = model.rangeOption
        distValue = model.distValue
        distUnits = model.distUnits
        regionCode = model.regionCode
    }

    func update(from model: PreferencesModel) {
        rangeOption = model.rangeOption
        distValue = model.distValue
        distUnits = model.distUnits
        regionCode = model.regionCode
    }
}

extension RangePreferenceSlice {
    func replace(into model: PreferencesModel) {
        model.rangeOption = rangeOption
        model.distValue = distValue
        model.distUnits = distUnits
        model.regionCode = regionCode
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public enum RangeType {
    case region(eBirdRegionInfo)
    case radius(CircleModel)
}

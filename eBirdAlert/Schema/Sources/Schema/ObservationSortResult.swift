// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

public enum ObservationSortResult<T: ObservationSortable> {
    case sorted([T])
    case grouped([(eBirdFamily, [T])])
}

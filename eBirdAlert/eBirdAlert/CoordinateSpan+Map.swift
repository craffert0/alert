// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema

public extension CoordinateSpan {
    init(from span: MKCoordinateSpan) {
        self.init(latitudeDelta: span.latitudeDelta,
                  longitudeDelta: span.longitudeDelta)
    }
}

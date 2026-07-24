// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

struct eBirdRegionInfoView: View {
    @State var info: eBirdRegionInfo

    var body: some View {
        VStack {
            Text(info.result).font(.headline)
            Text(info.code).font(.subheadline)
            Text(info.type.rawValue).font(.subheadline)
            if let bounds = info.bounds {
                mapView(bounds)
            }
        }
    }

    private func mapView(_ bounds: eBirdRegionInfo.Bounds) -> some View {
        Map {
            Marker(coordinate: info.coordinate.location) {}
            MapPolyline(coordinates: bounds.diamond.locations)
                .stroke(.blue, lineWidth: 5)
        }
    }
}

#Preview {
    TabView {
        Tab("XX", systemImage: "location") {
            eBirdRegionInfoView(info: .xx)
        }
        Tab("US", systemImage: "location") {
            eBirdRegionInfoView(info: .us)
        }
        Tab("NY", systemImage: "location") {
            eBirdRegionInfoView(info: .ny)
        }
        Tab("Kings", systemImage: "location.slash") {
            eBirdRegionInfoView(info: .kings)
        }
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

extension eBirdRegionInfo {
    var thread: [eBirdRegionInfo] {
        guard let parent else { return [self] }
        return [self] + parent.thread
    }
}

struct eBirdRegionInfoView: View {
    @State var info: eBirdRegionInfo

    var body: some View {
        VStack {
            Text(info.result).font(.headline)
            Text(info.thread.map(\.code).reversed().joined(separator: " => "))
                .font(.subheadline)
            Text(info.type.rawValue).font(.subheadline)
            if let bounds = info.bounds {
                mapView(bounds)
            }
        }
    }

    private func mapView(_ bounds: eBirdRegionInfo.Bounds) -> some View {
        Map {
            Marker(coordinate: info.coordinate) {}
            MapPolyline(coordinates: bounds.coordinates)
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

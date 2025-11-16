// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

extension eBirdRegionInfo {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension eBirdRegionInfo.Bounds {
    var coordinates: [CLLocationCoordinate2D] {
        [
            CLLocationCoordinate2D(latitude: minY, longitude: minX),
            CLLocationCoordinate2D(latitude: minY, longitude: maxX),
            CLLocationCoordinate2D(latitude: maxY, longitude: maxX),
            CLLocationCoordinate2D(latitude: maxY, longitude: minX),
            CLLocationCoordinate2D(latitude: minY, longitude: minX),
        ]
    }
}

struct eBirdRegionInfoView: View {
    @State var info: eBirdRegionInfo

    var body: some View {
        VStack {
            Text(info.result).font(.headline)
            Text(info.code).font(.subheadline)
            Text(info.type.rawValue).font(.subheadline)
            mapView
        }
    }

    private var mapView: some View {
        Map {
            Marker("centroid", coordinate: info.coordinate)
            if let bounds = info.bounds {
                MapPolyline(coordinates: bounds.coordinates)
                    .stroke(.blue, lineWidth: 5)
            }
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

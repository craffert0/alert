// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

struct RangeView: View {
    let range: RangeType?
    let onDismiss: () -> Void
    @State var showMap: Bool = false

    init(range: RangeType?,
         onDismiss: @escaping (() -> Void))
    {
        self.range = range
        self.onDismiss = onDismiss
    }

    var body: some View {
        HStack {
            if let range {
                Button {
                    showMap = true
                } label: {
                    switch range {
                    case let .radius(circle): radiusView(circle)
                    case let .region(regionInfo): regionView(regionInfo)
                    }
                }
            } else {
                Text("no birds")
            }
        }.sheet(isPresented: $showMap,
                onDismiss: onDismiss)
        {
            switch range! {
            case let .radius(circle): radiusMap(circle)
            case let .region(regionInfo): regionMap(regionInfo)
            }
        }
    }

    private func radiusView(_ circle: CircleModel) -> some View {
        HStack {
            Text("Within")
            Text(circle.radius.formatted(.eBirdFormat))
            Text(circle.units.rawValue)
        }
    }

    private func regionView(_ regionInfo: eBirdRegionInfo) -> some View {
        Text(regionInfo.result)
    }

    private func radiusMap(_ circle: CircleModel) -> some View {
        VStack {
            Text("Range")
            DistancePreferencesView(isInForm: false)
            Map {
                let coordinate = circle.location.coordinate
                Marker(coordinate: coordinate) {}
                MapCircle(
                    center: coordinate,
                    radius: 1000 * circle.units.asKilometers(circle.radius)
                )
                .foregroundStyle(.clear)
                .stroke(.blue, lineWidth: 5)
            }
        }
    }

    private func regionMap(_ regionInfo: eBirdRegionInfo) -> some View {
        VStack {
            regionView(regionInfo)
            Map {
                Marker(coordinate: regionInfo.coordinate) {}
                if let bounds = regionInfo.bounds {
                    MapPolyline(coordinates: bounds.coordinates)
                        .stroke(.blue, lineWidth: 5)
                }
            }
        }
    }
}

#Preview {
    let none: RangeType? = nil
    let region = RangeType.region(.kings)
    let radius = RangeType.radius(
        CircleModel(location: CLLocation(latitude: 40.67,
                                         longitude: -73.97),
                    radius: 2.3,
                    units: .miles))
    TabView {
        Tab("None", systemImage: "environments.circle") {
            RangeView(range: none) {}
        }
        Tab("Region", systemImage: "environments.circle") {
            RangeView(range: region) {}
        }
        Tab("Radius", systemImage: "environments.circle") {
            RangeView(range: radius) {}
        }
    }
}

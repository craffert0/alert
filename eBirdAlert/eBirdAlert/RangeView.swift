// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

struct RangeView: View {
    let range: RangeType?
    @State var showMap: Bool = false

    init(range: RangeType?) {
        self.range = range
    }

    var body: some View {
        HStack {
            if let range {
                buttonView(range)
            } else {
                Text("no birds")
            }
        }
    }

    private func buttonView(_ range: RangeType) -> some View {
        Button {
            showMap = true
        } label: {
            switch range {
            case let .radius(circle): radiusView(circle)
            case let .region(regionInfo): regionView(regionInfo)
            }
        }
        .sheet(isPresented: $showMap) {
            switch range {
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
            HStack {
                Button("Done") { showMap = false }
                Spacer()
                radiusView(circle)
            }.padding()
            Map {
                let coordinate = circle.location
                Marker(coordinate: coordinate.location) {}
                MapCircle(
                    center: coordinate.location,
                    radius: circle.units.asMeters(circle.radius)
                )
                .foregroundStyle(.clear)
                .stroke(.blue, lineWidth: 5)
            }
        }
    }

    private func regionMap(_ regionInfo: eBirdRegionInfo) -> some View {
        VStack {
            HStack {
                Button("Done") { showMap = false }
                Spacer()
                regionView(regionInfo)
            }.padding()
            Map {
                if let bounds = regionInfo.bounds {
                    MapPolyline(coordinates: bounds.coordinates.locations)
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
        CircleModel(location: Coordinate(latitude: 40.67,
                                         longitude: -73.97),
                    radius: 2.3,
                    units: .miles))
    TabView {
        Tab("None", systemImage: "environments.circle") {
            RangeView(range: none)
        }
        Tab("Region", systemImage: "environments.circle") {
            RangeView(range: region)
        }
        Tab("Radius", systemImage: "environments.circle") {
            RangeView(range: radius)
        }
    }
}

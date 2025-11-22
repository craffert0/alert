// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import SwiftUI

struct RangeView: View {
    @Environment(LocationService.self) var locationService
    @ObservedObject var preferences = PreferencesModel.global
    @State var showMap: Bool = false

    var body: some View {
        HStack {
            Button {
                showMap = true
            } label: {
                switch preferences.rangeOption {
                case .radius: radiusView
                case .region: regionView
                }
            }
        }.sheet(isPresented: $showMap) {
            switch preferences.rangeOption {
            case .radius: radiusMap
            case .region: regionMap
            }
        }
    }

    private var radiusView: some View {
        HStack {
            Text("Within")
            Text(preferences.distValue.formatted(.eBirdFormat))
            Text(preferences.distUnits.rawValue)
        }
    }

    private var regionView: some View {
        Text(preferences.regionInfo?.result ?? "In Region")
    }

    private var radiusMap: some View {
        VStack {
            radiusView
            Map {
                let coordinate = locationService.location!.coordinate
                Marker(coordinate: coordinate) {}
                MapCircle(
                    center: coordinate,
                    radius: 1000 * preferences.distUnits.asKilometers(
                        preferences.distValue)
                )
                .foregroundStyle(.clear)
                .stroke(.blue, lineWidth: 5)
            }
        }
    }

    private var regionMap: some View {
        VStack {
            regionView
            Map {
                let info = preferences.regionInfo!
                Marker(coordinate: info.coordinate) {}
                if let bounds = info.bounds {
                    MapPolyline(coordinates: bounds.coordinates)
                        .stroke(.blue, lineWidth: 5)
                }
            }
        }
    }
}

#Preview {
    VStack {
        RangeView()
    }
}

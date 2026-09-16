// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

struct RangePreferenceView: View {
    @Environment(LocationService.self) var locationService
    @Environment(\.dismiss) private var dismiss
    @State var slice: RangePreferenceSlice

    init(slice: RangePreferenceSlice) {
        slice.update(from: PreferencesModel.global)
        self.slice = slice
    }

    var body: some View {
        VStack {
            HStack {
                Button("Done") { dismiss() }
                Spacer()
                Picker("Location", selection: $slice.rangeOption) {
                    Text("Search nearby").tag(RangeOption.radius)
                    Text("Search by county").tag(RangeOption.region)
                }
            }.padding()
            switch slice.rangeOption {
            case .radius: radiusView
            case .region: regionView
            }
        }
    }

    private var radiusView: some View {
        VStack {
            DistancePreferencesView(isInForm: false, slice: slice)
                .padding()
            if let location = locationService.location {
                Map {
                    UserAnnotation()
                    MapCircle(
                        center: location.location,
                        radius: slice.distUnits.asMeters(slice.distValue)
                    )
                    .foregroundStyle(.clear)
                    .stroke(.blue, lineWidth: 5)
                }
            }
        }
    }

    private var regionView: some View {
        LocalRegionView(regionService: FixedRegionService.global,
                        slice: slice)
    }
}

#Preview {
    let noLocation = LocationService()
    let brooklyn: LocationService = {
        let l = LocationService()
        l.location = Coordinate(latitude: 40.65, longitude: -74)
        return l
    }()
    let slice = RangePreferenceSlice(from: PreferencesModel.global)
    TabView {
        Tab("location", systemImage: "environments.circle") {
            RangePreferenceView(slice: slice)
                .environment(brooklyn)
        }
        Tab("none", systemImage: "bird.circle") {
            RangePreferenceView(slice: slice)
                .environment(noLocation)
        }
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import SwiftUI

struct RangePreferenceView: View {
    @Environment(LocationService.self) var locationService
    @ObservedObject var preferences = PreferencesModel.global

    var body: some View {
        VStack {
            HStack {
                Text("Location Style")
                Picker("Location", selection: preferences.$rangeOption) {
                    Text("Nearby").tag(RangeOption.radius)
                    Text("County").tag(RangeOption.region)
                }
            }
            switch preferences.rangeOption {
            case .radius: radiusView
            case .region: regionView
            }
        }
    }

    private var radiusView: some View {
        VStack {
            DistancePreferencesView(isInForm: false)
            if let location = locationService.location {
                Map {
                    UserAnnotation()
                    MapCircle(
                        center: location.coordinate,
                        radius: preferences.distUnits.asMeters(preferences.distValue)
                    )
                    .foregroundStyle(.clear)
                    .stroke(.blue, lineWidth: 5)
                }
            }
        }
    }

    private var regionView: some View {
        LocalRegionView(regionService: URLSession.region)
    }
}

#Preview {
    let noLocation = LocationService()
    let brooklyn: LocationService = {
        let l = LocationService()
        l.location = CLLocation(latitude: 40.65, longitude: -74)
        return l
    }()
    TabView {
        Tab("location", systemImage: "environments.circle") {
            RangePreferenceView()
                .environment(brooklyn)
        }
        Tab("none", systemImage: "bird.circle") {
            RangePreferenceView()
                .environment(noLocation)
        }
    }
}

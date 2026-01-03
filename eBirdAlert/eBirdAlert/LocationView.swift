// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LocationView: View {
    @Environment(LocationService.self) var locationService
    @ObservedObject var preferences = PreferencesModel.global
    @State var showRange: Bool = false
    @State var range: RangeType? = nil
    private let service: eBirdRegionService = URLSession.region
    private let onChange: (() async -> Void)?

    init(onChange: (() async -> Void)? = nil) {
        self.onChange = onChange
    }

    var body: some View {
        Button {
            showRange = true
        } label: {
            if let range {
                switch range {
                case let .region(regionInfo):
                    Text(regionInfo.result)
                case let .radius(circle):
                    HStack {
                        Text("Within")
                        Text(circle.radius.formatted(.eBirdFormat))
                        Text(circle.units.rawValue)
                    }
                }
            } else {
                Text("TODO: oops")
            }
        }
        .task {
            _ = await loadRange()
        }
        .sheet(isPresented: $showRange,
               onDismiss: {
                   Task { @MainActor in
                       if await loadRange(),
                          let onChange
                       {
                           await onChange()
                       }
                   }
               }) {
            RangePreferenceView()
        }
    }

    private func loadRange() async -> Bool {
        let oldRange = range
        range = try? await preferences.range(for: locationService.location,
                                             with: service)
        return range != oldRange
    }
}

#Preview {
    let locationService: LocationService =
        FixedLocationService(latitude: 41, longitude: -74)
    VStack {
        LocationView()
            .environment(locationService)
    }
}

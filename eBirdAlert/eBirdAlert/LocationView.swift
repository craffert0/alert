// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LocationView: View {
    @Environment(LocationService.self) var locationService
    @ObservedObject var preferences = PreferencesModel.global
    @State var showRange: Bool = false
    @State var range: RangeType? = nil
    private let service: eBirdRegionService = FixedRegionService.global
    private let onChange: () async -> Void

    init(onChange: @escaping (() async -> Void)) {
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
                Text("Select a county.")
            }
        }
        .task(id: range) {
            if range == nil {
                reloadRange()
            } else {
                await onChange()
            }
        }
        .sheet(isPresented: $showRange,
               onDismiss: reloadRange)
        {
            RangePreferenceView()
        }
    }

    private func reloadRange() {
        range = try? preferences.range(for: locationService.location,
                                       with: service)
    }
}

#Preview {
    let locationService: LocationService =
        FixedLocationService(latitude: 41, longitude: -74)
    VStack {
        LocationView {
            print("load it")
        }
    }.environment(locationService)
}

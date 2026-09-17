// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LocationView: View {
    @Environment(LocationService.self) var locationService
    @ObservedObject var preferences = PreferencesModel.global
    @State var showRange: Bool = false
    @State var range: RangeType? = nil
    @State var slice = RangePreferenceSlice(from: PreferencesModel.global)
    private let service: eBirdRegionService = FixedRegionService.global

    var body: some View {
        Button {
            showRange = true
        } label: {
            if let range {
                range.view
            } else {
                Text("Select a county.")
            }
        }
        .task {
            reloadRange()
        }
        .onChange(of: preferences.lookupOption) {
            reloadRange()
        }
        .sheet(isPresented: $showRange) {
            slice.replace(into: PreferencesModel.global)
        } content: {
            RangePreferenceView(slice: slice)
        }
    }

    private func reloadRange() {
        range = try? preferences.range(for: locationService.location,
                                       with: service)
    }
}

private extension RangeType {
    @ViewBuilder
    var view: some View {
        switch self {
        case let .region(regionInfo):
            regionInfo.nameView
        case let .radius(circle):
            HStack {
                Text("Within")
                Text(circle.radius.formatted(.eBirdFormat))
                Text(circle.units.rawValue)
            }
        }
    }
}

#Preview {
    let locationService: LocationService =
        FixedLocationService(latitude: 41, longitude: -74)
    VStack {
        LocationView()
    }.environment(locationService)
}

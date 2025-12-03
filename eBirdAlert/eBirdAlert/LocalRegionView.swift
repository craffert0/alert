// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI

struct LocalRegionView: View {
    var regionService: any eBirdRegionService
    @Environment(LocationService.self) var locationService
    @State var regions: [eBirdRegionInfo] = []
    @State var showError: Bool = false
    @State var error: eBirdServiceError? = nil
    private var selectedCode = Binding {
        PreferencesModel.global.regionCode
    } set: { newValue in
        Task { @MainActor in
            PreferencesModel.global.regionCode = newValue
        }
    }

    init(regionService: any eBirdRegionService) {
        self.regionService = regionService
    }

    var body: some View {
        VStack {
            if regions.isEmpty {
                Text("loading regions...")
                ProgressView()
            } else {
                mapView
            }
        }
        .task {
            await load()
        }
        .refreshable {
            await load()
        }
        .alert(isPresented: $showError, error: error) {}
    }

    private var mapView: some View {
        VStack {
            List(regions, selection: selectedCode) {
                Text($0.result)
            }
            Map {
                ForEach(regions) { info in
                    if let bounds = info.bounds {
                        box(for: bounds, with: info.code == selectedCode.wrappedValue)
                    }
                }
                UserAnnotation()
            }
        }
    }

    private func box(for bounds: eBirdRegionInfo.Bounds,
                     with selected: Bool) -> some MapContent
    {
        MapPolyline(coordinates: bounds.coordinates)
            .stroke(selected ? .blue : .red,
                    lineWidth: selected ? 5 : 2)
    }

    private func load() async {
        do {
            guard let location = locationService.location else {
                throw eBirdServiceError.noLocation
            }
            try await regions =
                regionService.getRegions(near: location).sorted {
                    $0.distance2(location) ?? 0 < $1.distance2(location) ?? 0
                }
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
    }
}

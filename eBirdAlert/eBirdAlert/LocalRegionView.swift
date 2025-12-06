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
    @ObservedObject var preferences = PreferencesModel.global

    init(regionService: any eBirdRegionService) {
        self.regionService = regionService
    }

    var body: some View {
        VStack {
            Text(title)
            mapView
        }
        .task { await load() }
        .alert(isPresented: $showError, error: error) {}
    }

    private var mapView: some View {
        Map(selection: preferences.$regionCode) {
            ForEach(regions) { info in
                Marker(info.result, coordinate: info.coordinate)
                    .tag(info.code)
                if let bounds = info.bounds {
                    box(for: bounds,
                        with: info.code == preferences.regionCode)
                }
            }
            UserAnnotation()
        }
        .mapStyle(.standard(pointsOfInterest: []))
    }

    private var title: String {
        if let regionCode = preferences.regionCode,
           let info = regions.first(where: { $0.code == regionCode })
        {
            info.result
        } else if regions.isEmpty {
            "loading regions..."
        } else {
            "Search current county"
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
            try await regions = regionService.getRegions(near: location)
            if let code = preferences.regionCode,
               !regions.contains(where: { $0.code == code }),
               let region = try? await regionService.getInfo(for: code)
            {
                regions.append(region)
            }
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
    }
}

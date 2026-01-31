// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI
import URLNetwork

struct LocalRegionView: View {
    var regionService: any eBirdRegionService
    @Environment(LocationService.self) var locationService
    @State var position: MapCameraPosition = .automatic
    @State var regions: [eBirdRegionInfo] = []
    @State var isLoading: Bool = true
    @State var showError: Bool = false
    @State var error: eBirdServiceError? = nil
    @ObservedObject var preferences = PreferencesModel.global

    var body: some View {
        VStack {
            Text(title)
            mapView
        }
        .task { await load() }
        .alert(isPresented: $showError, error: error) {}
    }

    private var mapView: some View {
        Map(position: $position, selection: preferences.$regionCode) {
            ForEach(regions) { info in
                Marker(info.result, coordinate: info.coordinate.location)
                    .tag(info.code)
                if let bounds = info.bounds {
                    box(for: bounds,
                        with: info.code == preferences.regionCode)
                }
            }
            UserAnnotation()
        }
        .mapStyle(.standard(pointsOfInterest: []))
        .onMapCameraChange(frequency: .onEnd) { updateContext in
            if position.positionedByUser {
                updateRegions(updateContext)
            }
        }
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
        MapPolyline(coordinates: bounds.coordinates.locations)
            .stroke(selected ? .primary : .secondary,
                    lineWidth: selected ? 5 : 2)
    }

    private func load() async {
        do {
            guard let location = locationService.location else {
                throw eBirdServiceError.noLocation
            }
            isLoading = true
            regions = try await getRegions(
                at: location,
                around: .init(latitudeDelta: 0.4,
                              longitudeDelta: 0.3)
            )
            isLoading = false
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
            isLoading = false
        }
    }

    private func updateRegions(_ context: MapCameraUpdateContext) {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                let regions = try await getRegions(
                    at: .init(from: context.region.center),
                    around: .init(from: context.region.span)
                )
                Task { @MainActor in
                    self.regions = regions
                    isLoading = false
                }
            } catch {
                Task { @MainActor in
                    self.error = eBirdServiceError.from(error)
                    showError = true
                    isLoading = false
                }
            }
        }
    }

    private func getRegions(at location: Coordinate,
                            around span: CoordinateSpan) async throws
        -> [eBirdRegionInfo]
    {
        let regions =
            try await regionService.getRegions(at: location,
                                               around: span)
        if let code = preferences.regionCode,
           !regions.contains(where: { $0.code == code }),
           let region = try? await regionService.getInfo(for: code)
        {
            return regions + [region]
        } else {
            return regions
        }
    }
}

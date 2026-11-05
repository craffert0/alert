// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import MapKit
import Schema
import SwiftUI
import URLNetwork

private let kMaxRegions = 384

struct LocalRegionView: View {
    var regionService: any eBirdRegionService
    @State var slice: RangePreferenceSlice

    @Environment(LocationService.self) var locationService
    @State var position: MapCameraPosition = .automatic
    @State var regions: [eBirdRegionInfo] = []
    @State var showError: Bool = false
    @State var error: eBirdServiceError? = nil
    @State var everPositionedByUser = false

    var body: some View {
        VStack {
            titleView
            mapView
        }
        .task { await load() }
        .alert(isPresented: $showError, error: error) {}
    }

    private var mapView: some View {
        Map(position: $position, selection: $slice.regionCode) {
            UserAnnotation()
            if regions.count < kMaxRegions {
                ForEach(regions) { info in
                    info.marker
                    info.bounds?.box(fancy: info.code == slice.regionCode)
                }
            } else if let info = regions.first(
                where: { $0.code == slice.regionCode }
            ) {
                info.marker
                info.bounds?.box()
            }
        }
        .mapStyle(.standard(pointsOfInterest: []))
        .mapControls {
            MapUserLocationButton()
        }
        .onMapCameraChange(frequency: .onEnd) { updateContext in
            if position.positionedByUser {
                everPositionedByUser = true
            }
            if everPositionedByUser {
                Task { @MainActor in
                    await updateRegions(updateContext)
                }
            }
        }
    }

    @ViewBuilder
    private var titleView: some View {
        if let regionCode = slice.regionCode,
           let info = regions.first(where: { $0.code == regionCode })
        {
            info.nameView
        } else if regions.isEmpty {
            Text("loading regions...")
        } else {
            Text("Search current county")
        }
    }

    private func load() async {
        if let regionCode = slice.regionCode,
           let region = await regionService.getInfo(for: regionCode),
           let bounds = region.bounds
        {
            // region is selected so go there.
            await updateRegions(
                at: region.coordinate,
                around: .init(latitudeDelta: latitudeDelta(bounds.maxY - bounds.minY),
                              longitudeDelta: longitudeDelta(bounds.maxX - bounds.minX))
            )
        } else if let location = locationService.location {
            // no region so look around us
            await updateRegions(
                at: location,
                around: .init(latitudeDelta: latitudeDelta(),
                              longitudeDelta: longitudeDelta())
            )
        } else {
            // ugh.
            error = .noLocation
            showError = true
        }
    }

    private func updateRegions(_ context: MapCameraUpdateContext) async {
        await updateRegions(
            at: .init(from: context.region.center),
            around: .init(from: context.region.span)
        )
    }

    private func updateRegions(at location: Coordinate,
                               around span: CoordinateSpan) async
    {
        let regions =
            await regionService.getRegions(at: location,
                                           around: span)
        if let code = slice.regionCode,
           !regions.contains(where: { $0.code == code }),
           let region = await regionService.getInfo(for: code)
        {
            self.regions = regions + [region]
        } else {
            self.regions = regions
        }
    }
}

private func latitudeDelta(_ min: Double = 0.0) -> Double {
    max(0.4, min)
}

private func longitudeDelta(_ min: Double = 0.0) -> Double {
    max(0.3, min)
}

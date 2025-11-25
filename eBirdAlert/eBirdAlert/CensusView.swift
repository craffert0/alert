// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import MapKit
import Schema
import SwiftUI

struct CensusView: View {
    var service: any CensusService
    @Environment(LocationService.self) var locationService
    @State var info: eBirdRegionInfo?
    @State var showError: Bool = false
    @State var error: eBirdServiceError? = nil

    var body: some View {
        VStack {
            if let info {
                eBirdRegionInfoView(info: info)
            } else if locationService.location == nil {
                Text("no location 😢")
            } else {
                Text("waiting...")
                    .task {
                        await load()
                    }
            }
        }
        .alert(isPresented: $showError, error: error) {}
    }

    private func load() async {
        do {
            guard let location = locationService.location else {
                throw eBirdServiceError.noLocation
            }
            info = try await URLSession.cached.getInfo(
                of: service.getCensusTract(for: location)
            )
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
    }
}

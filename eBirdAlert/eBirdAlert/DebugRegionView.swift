// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct DebugRegionView: View {
    var service: any eBirdRegionService
    var region: eBirdRegion
    var type: eBirdRegionType
    @State var subregions: [eBirdRegion] = []
    @State var info: eBirdRegionInfo? = nil
    @State var showError: Bool = false
    @State var error: eBirdServiceError? = nil

    init(service: any eBirdRegionService,
         region: eBirdRegion,
         type: eBirdRegionType)
    {
        self.service = service
        self.region = region
        self.type = type
    }

    init(service: any eBirdRegionService) {
        self.init(service: service, region: .world, type: .custom)
    }

    var body: some View {
        VStack {
            if !subregions.isEmpty {
                listView
            }
            if let info {
                eBirdRegionInfoView(info: info)
            }
        }
        .navigationTitle(region.name)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await load()
        }
        .alert(isPresented: $showError, error: error) {}
    }

    private var listView: some View {
        List(subregions) { r in
            NavigationLink {
                if let subtype = type.subtype {
                    DebugRegionView(service: service, region: r, type: subtype)
                } else {
                    Text(r.name)
                }
            } label: {
                Text(r.name)
            }
        }
        .listStyle(.automatic)
    }
}

extension DebugRegionView {
    private func load() async {
        do {
            if let subtype = type.subtype, subregions.count == 0 {
                subregions =
                    try await service.getSubRegions(of: region, as: subtype)
            }
            if info == nil {
                info = try await service.getInfo(of: region)
            }
        } catch {
            self.error = eBirdServiceError.from(error)
            showError = true
        }
    }
}

// #Preview {
//     VStack {
//         DebugRegionView()
//     }
// }

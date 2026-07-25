// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct EmptyView: View {
    @ObservedObject var preferences = PreferencesModel.global
    let name: String
    let range: RangeType?

    var body: some View {
        VStack {
            if let range {
                switch range {
                case let .region(info):
                    infoView(info)
                case let .radius(circle):
                    circleView(circle)
                }
            } else {
                noRegionView
            }
        }
        .navigationTitle("No \(name.capitalized) Birds")
    }

    private func infoView(_ info: eBirdRegionInfo) -> some View {
        Form {
            daysBack("in " + info.result)
            bigText("Consider looking back further.")
        }
    }

    private func circleView(_ circle: CircleModel) -> some View {
        Form {
            daysBack("within " + circle.radius.formatted(.eBirdFormat)
                + " "
                + circle.units.rawValue)
            bigText("Consider expanding your range in your Settings.")
        }
    }

    private var noRegionView: some View {
        VStack {
            bigText("loading...")
            ProgressView()
        }
    }

    private func bigText(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.largeTitle)
    }

    private func daysBack(_ text: String) -> some View {
        let daysBack = Int(preferences.daysBack)
        let days = daysBack == 1 ? "day" : "\(daysBack) days"
        let have = daysBack == 1 ? "has" : "have"
        let sighting = daysBack == 1 ? "sighting" : "sightings"

        return bigText("In the past \(days), there \(have) been no" +
            " \(name) bird \(sighting) \(text).")
    }
}

#Preview {
    TabView {
        Tab("region", systemImage: "environments.circle") {
            NavigationStack {
                EmptyView(name: "empty",
                          range: .region(.kings))
            }
        }
        Tab("radius", systemImage: "environments.circle") {
            NavigationStack {
                EmptyView(name: "empty",
                          range: .radius(
                              CircleModel(
                                  location: Coordinate(latitude: 40.65,
                                                       longitude: -74),
                                  radius: 2.3,
                                  units: .miles
                              )
                          ))
            }
        }
        Tab("none", systemImage: "environments.circle") {
            NavigationStack {
                EmptyView(name: "empty",
                          range: nil)
            }
        }
    }
}

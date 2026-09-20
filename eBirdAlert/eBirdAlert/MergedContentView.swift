// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import SwiftUI

protocol MergedContentProtocol {
    var sciName: String { get }
    var speciesCode: String { get }
    var comName: String { get }
}

struct MergedContentView<
    Observation: MergedContentProtocol,
    Content: View
>: View {
    let observation: Observation
    let content: () -> Content

    init(_ observation: Observation,
         content: @escaping () -> Content)
    {
        self.observation = observation
        self.content = content
    }

    var body: some View {
        VStack {
            Text(observation.sciName)
            Spacer()

            BirdButtonsView(speciesCode: observation.speciesCode)

            content()
        }
        .navigationTitle(observation.comName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

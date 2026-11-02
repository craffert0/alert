// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BackgroundTasks
import SwiftUI

// NOTES
// Maybe this calls NotableObservationsProvider.load() in refresh()

struct RefreshService {
    let notificationService: NotificationService
    let mergedModel: MergedModel

    // The user saw these birds' speciesCodes.
    @AppStorage("system.lastViewedNotables")
    var lastViewedNotables: Set<String> = []

    // The user has seen these birds' speciesCodes or been notified about
    // them.
    @AppStorage("system.lastLoadedNotables")
    var lastLoadedNotables: Set<String> = []

    func schedule() throws {
        lastViewedNotables = mergedModel.speciesCodes
        lastLoadedNotables = lastViewedNotables
        try reschedule()
    }

    func refresh() async throws {
        await mergedModel.refreshNotables()
        let notables = mergedModel.speciesCodes
        let newBirds = notables.subtracting(lastLoadedNotables)
        if !newBirds.isEmpty {
            lastLoadedNotables = notables
            let names = newBirds.map { speciesCode in
                mergedModel.notableObservations.first(
                    where: { $0.speciesCode == speciesCode }
                )?.comName ?? speciesCode
            }
            let badge = notables.subtracting(lastViewedNotables).count
            try await notificationService.notify(for: names,
                                                 badge: badge)
        }
        try reschedule()
    }

    private func reschedule() throws {
        let request = BGAppRefreshTaskRequest(id: .refreshCounter)
        request.earliestBeginDate =
            Calendar.current.date(byAdding: .minute, value: 11, to: Date())
        try BGTaskScheduler.shared.submit(request)
    }
}

extension MergedModel {
    var speciesCodes: Set<String> {
        Set(notableObservations.map(\.speciesCode))
    }
}

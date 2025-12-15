// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BackgroundTasks

// NOTES
// PreferencesView: delete now & timeView & diffView
// Maybe this calls NotableObservationsProvider.load() in refresh()
// Next step: notify on refresh

struct RefreshService {
    func schedule() throws {
        let request = BGAppRefreshTaskRequest(id: .refreshCounter)
        request.earliestBeginDate =
            Calendar.current.date(byAdding: .minute, value: 13, to: Date())
        try BGTaskScheduler.shared.submit(request)
        PreferencesModel.global.timeRequested = Date.now
    }

    func refresh() async throws {
        PreferencesModel.global.timeFired = Date.now
        try schedule()
    }
}

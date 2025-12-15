// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BackgroundTasks

// NOTES
// Maybe this calls NotableObservationsProvider.load() in refresh()

struct RefreshService {
    let notificationService: NotificationService

    func schedule() throws {
        let request = BGAppRefreshTaskRequest(id: .refreshCounter)
        request.earliestBeginDate =
            Calendar.current.date(byAdding: .minute, value: 13, to: Date())
        try BGTaskScheduler.shared.submit(request)
        print("schedule: \(Date.now)")
    }

    func refresh() async throws {
        print("fired: \(Date.now)")
        await notificationService.fakeNotify()
        try schedule()
    }
}

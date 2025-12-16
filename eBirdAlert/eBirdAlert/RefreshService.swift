// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BackgroundTasks

// NOTES
// Maybe this calls NotableObservationsProvider.load() in refresh()

class RefreshService {
    let notificationService: NotificationService

    let birds = [
        "American Pipit",
        "Bald Eagle",
        "Black & White Warbler",
        "Greater Scaup",
    ]
    var bird = 0

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func schedule() throws {
        let request = BGAppRefreshTaskRequest(id: .refreshCounter)
        request.earliestBeginDate =
            Calendar.current.date(byAdding: .minute, value: 11, to: Date())
        try BGTaskScheduler.shared.submit(request)
        print("schedule: \(Date.now)")
    }

    func refresh() async throws {
        print("fired: \(Date.now)")
        bird = (bird + 1) % birds.count
        try await notificationService.notify(for: Array(birds.prefix(bird)),
                                             badge: birds.count - bird)
        try schedule()
    }
}

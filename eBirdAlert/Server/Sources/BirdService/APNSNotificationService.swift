// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import APNS
import APNSURLSession
import Foundation

struct APNSNotificationService: NotificationService {
    typealias Client = APNSURLSessionClient

    let developmentClient: Client
    let productionClient: Client

    init(teamIdentifier: String,
         keyIdentifier: String,
         privateKey: String) throws
    {
        developmentClient = try .init(teamIdentifier: teamIdentifier,
                                      keyIdentifier: keyIdentifier,
                                      privateKey: privateKey,
                                      environment: .development)
        productionClient = try .init(teamIdentifier: teamIdentifier,
                                     keyIdentifier: keyIdentifier,
                                     privateKey: privateKey,
                                     environment: .production)
    }

    func notify(_ deviceId: String,
                deviceType: Components.Schemas.DeviceType,
                newBirds: Set<String>,
                badgeCount: Int) async throws
    {
        switch deviceType {
        case .production:
            try await productionClient.sendAlertNotification(
                .init(newBirds: newBirds, badgeCount: badgeCount),
                deviceToken: deviceId
            )
        case .development:
            try await developmentClient.sendAlertNotification(
                .init(newBirds: newBirds, badgeCount: badgeCount),
                deviceToken: deviceId
            )
        }
    }
}

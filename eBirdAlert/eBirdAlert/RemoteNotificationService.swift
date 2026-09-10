// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import AlertAPI
import OpenAPIURLSession
import Schema

struct RemoteNotificationService {
    func register(range: RangeType,
                  daysBack: Int,
                  birdsSeen: [BirdObservations])
    {
        guard case let .server(userToken, deviceId) =
            PreferencesModel.global.notificationType
        else { return }

        Task {
            _ = try? await Client(serverURL: Servers.Server1.url(),
                                  transport: URLSessionTransport())
                .postNotableQuery(
                    .init(body: .json(
                        .init(
                            userToken: userToken,
                            deviceId: deviceId.hex,
                            deviceType: .current,
                            range: range.api,
                            daysBack: daysBack,
                            results: birdsSeen.map(\.speciesCode)
                        )
                    ))
                )
        }
    }
}

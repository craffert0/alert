// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import APNS
import Foundation
import NIOCore

extension APNSClient<JSONDecoder, JSONEncoder> {
    convenience init(teamIdentifier: String,
                     keyIdentifier: String,
                     privateKey: String) throws
    {
        try self.init(
            configuration: .init(
                authenticationMethod: .jwt(
                    privateKey: .init(pemRepresentation: privateKey),
                    keyIdentifier: keyIdentifier,
                    teamIdentifier: teamIdentifier
                ),
                environment: .development
            ),
            eventLoopGroupProvider: (WorkaroundS() as WorkaroundP).get(),
            responseDecoder: JSONDecoder(),
            requestEncoder: JSONEncoder()
        )
    }
}

// https://stackoverflow.com/a/45743766

protocol WorkaroundP {
    func get() -> NIOEventLoopGroupProvider
}

struct WorkaroundS: WorkaroundP {
    @available(*, deprecated)
    func get() -> NIOEventLoopGroupProvider {
        .createNew
    }
}

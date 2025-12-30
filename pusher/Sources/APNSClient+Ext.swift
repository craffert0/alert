// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import APNS
import Foundation

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
            eventLoopGroupProvider: .createNew,
            responseDecoder: JSONDecoder(),
            requestEncoder: JSONEncoder()
        )
    }
}

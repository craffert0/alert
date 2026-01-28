// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import APNS
import APNSCore
import APNSURLSession

extension APNSURLSessionClient: @retroactive @unchecked Sendable {
    init(teamIdentifier: String,
         keyIdentifier: String,
         privateKey: String,
         environment: APNSEnvironment) throws
    {
        try self.init(
            configuration: .init(
                environment: environment,
                privateKey: .init(pemRepresentation: privateKey),
                keyIdentifier: keyIdentifier,
                teamIdentifier: teamIdentifier
            )
        )
    }
}

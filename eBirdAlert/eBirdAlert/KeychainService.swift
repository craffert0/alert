// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct KeychainService {
    static let global = KeychainService()

    static let server = "api.ebird.org"

    var applicationKey: String {
        get throws {
            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrServer as String: KeychainService.server,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnAttributes as String: true,
                kSecReturnData as String: true,
            ]

            // Get the item holding the credentials
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            guard status != errSecItemNotFound else {
                throw KeychainError.noApplicationKey
            }
            guard status == errSecSuccess else {
                throw KeychainError.unhandledError(status: status)
            }

            // Extract the credentials
            guard let actual = item as? [String: Any],
                  let keyData = actual[kSecValueData as String] as? Data,
                  let applicationKey = String(data: keyData, encoding: .utf8)
            else {
                throw KeychainError.unexpectedApplicationKeyData
            }
            return applicationKey
        }
    }

    func set(applicationKey: String) throws {
        let keyData = Data(applicationKey.utf8)
        if try tryUpdate(keyData: keyData) {
            return
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: KeychainService.server,
            kSecValueData as String: keyData,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    private func tryUpdate(keyData: Data) throws -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: KeychainService.server,
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: keyData,
        ]
        let status = SecItemUpdate(query as CFDictionary,
                                   attributes as CFDictionary)
        return status == errSecSuccess
    }
}

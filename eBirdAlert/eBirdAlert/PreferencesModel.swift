// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import Schema
import SwiftUI
import URLNetwork

class PreferencesModel: ObservableObject {
    static let global = PreferencesModel()

    @AppStorage("settings.daysBack") var daysBack: Int = 2
    @AppStorage("settings.rangeOption") var rangeOption: RangeOption = .radius
    @AppStorage("settings.distValue") var distValue: Double = 3
    @AppStorage("settings.distUnits") var distUnits: DistanceUnits = .miles
    @AppStorage("settings.regionCode") var regionCode: String?
    @AppStorage("settings.mapType") var mapType: MapOption = .apple
    @AppStorage("settings.mapDirectionsType")
    var directionsType: MapDirectionsOption = .none
    @AppStorage("settings.notifyNotable") var notifyNotable: Bool = false
    @AppStorage("settings.userToken") var userToken: String?
    @AppStorage("settings.notable.sort")
    var notableSort: ObservationSortOption = .byTime
    @AppStorage("settings.locals.sort")
    var localsSort: ObservationSortOption = .byTaxon
    @Published var debugMode: Bool = false
    var deviceToken: Data?
}

extension PreferencesModel {
    func range(for location: Coordinate?,
               with service: eBirdRegionService) throws -> RangeType
    {
        switch rangeOption {
        case .radius:
            guard let location else { throw eBirdServiceError.noLocation }
            return .radius(CircleModel(location: location,
                                       radius: distValue,
                                       units: distUnits))
        case .region:
            if let regionCode {
                guard let info = service.getInfo(for: regionCode) else {
                    throw eBirdServiceError.noRegion(regionCode: regionCode)
                }
                return .region(info)
            } else {
                guard let location else {
                    throw eBirdServiceError.noLocation
                }
                guard let region = service.getRegion(at: location) else {
                    throw eBirdServiceError.noLocationRegion
                }
                return .region(region)
            }
        }
    }

    var notificationType: NotificationType {
        if !notifyNotable {
            .none
        } else if let userToken,
                  userToken != "",
                  let deviceToken
        {
            .server(userToken, deviceToken)
        } else {
            .local
        }
    }
}

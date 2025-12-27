// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import CoreLocation
import Schema
import SwiftUI

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
    @AppStorage("settings.notable.sort")
    var notableSort: ObservationSortOption = .byTime
    @AppStorage("settings.locals.sort")
    var localsSort: ObservationSortOption = .byTaxon
    @Published var debugMode: Bool = false
    let maxDistance: Double = 250
}

extension PreferencesModel {
    var daysBackString: String {
        if daysBack == 1 {
            "Past day"
        } else {
            "Past \(daysBack) days"
        }
    }

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "detail", value: "full"),
            URLQueryItem(name: "hotspot", value: "false"),
            URLQueryItem(name: "back", value: "\(daysBack)"),
        ]
    }

    var geoQueryItems: [URLQueryItem] {
        queryItems + [URLQueryItem(name: "dist",
                                   value: "\(distUnits.asKilometers(distValue))")]
    }

    func range(for location: CLLocation?,
               with service: eBirdRegionService) async throws -> RangeType
    {
        switch rangeOption {
        case .radius:
            guard let location else { throw eBirdServiceError.noLocation }
            return .radius(CircleModel(location: location,
                                       radius: distValue,
                                       units: distUnits))
        case .region:
            if let regionCode {
                return try await .region(service.getInfo(for: regionCode))
            } else {
                guard let location else { throw eBirdServiceError.noLocation }
                return try await .region(
                    service.getInfo(for: service.getCensusTract(
                        for: location).code))
            }
        }
    }
}

// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

typealias Checklist = SchemaV1.Checklist

extension Checklist {
    var userDisplayName: String? {
        guard case let .value(checklist) = status else {
            return nil
        }
        return checklist.userDisplayName
    }

    var formattedDates: String {
        if case let .value(checklist) = status,
           let durationHrs = checklist.durationHrs
        {
            let end =
                date.addingTimeInterval(3600 * TimeInterval(durationHrs))
            return "\(date.eBirdFormatted) - \(end.formatted(.timeOnlyFormat))"
        } else {
            return date.eBirdFormatted
        }
    }

    func observation(for speciesCode: String) -> eBirdChecklist.Obs? {
        guard case let .value(checklist) = status else {
            return nil
        }
        return checklist.obs.first { $0.speciesCode == speciesCode }
    }

    func refresh(timeZone: TimeZone) async {
        guard case .value = status else { return }
        if let e = try? await eBirdServiceGlobal.getChecklist(subId: id, timeZone: timeZone) {
            date = e.obsDt
            status = .value(checklist: e)
        }
    }

    func load(timeZone: TimeZone) {
        guard case .unloaded = status else { return }
        status = .loading(startTime: Date.now)
        Task {
            do {
                let e = try await eBirdServiceGlobal.getChecklist(subId: id, timeZone: timeZone)
                Task { @MainActor in
                    self.date = e.obsDt
                    self.status = .value(checklist: e)
                }
            } catch {
                let e = error
                Task { @MainActor in
                    self.status = .error(reason: "\(e)")
                }
            }
        }
    }
}

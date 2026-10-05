// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import Testing

enum MyError: Error {
    case notSorted
    case notGrouped
}

extension ObservationSortResult {
    var isEmpty: Bool {
        switch self {
        case let .sorted(a): a.isEmpty
        case let .grouped(g): g.isEmpty
        }
    }
}

struct ObservationSortOptionTest {
    let fakeObservations = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .eBirdStyle
        return try! d.decode(
            [FakeObservationSortable].self,
            from: Data(contentsOf: Bundle.module.url(forResource: "FakeObservations",
                                                     withExtension: "json")!)
        ).shuffled()
    }()

    @Test func emptySorts() {
        let fakes: [FakeObservationSortable] = []
        #expect(fakes.sorted(.byTime).isEmpty)
        #expect(fakes.sorted(.byName).isEmpty)
        #expect(fakes.sorted(.byTaxon).isEmpty)
    }

    @Test func singleSort() throws {
        let fake = try #require(fakeObservations.first)
        let fakes = [fake]

        guard case let .sorted(byTime) = fakes.sorted(.byTime) else {
            throw MyError.notSorted
        }
        try #require(byTime.count == 1)
        #expect(try #require(byTime.first).comName == fake.comName)

        guard case let .sorted(byName) = fakes.sorted(.byName) else {
            throw MyError.notSorted
        }
        try #require(byName.count == 1)
        #expect(try #require(byName.first).comName == fake.comName)
    }

    @Test func singleGroup() throws {
        let fake = try #require(fakeObservations.first)
        let fakes = [fake]

        guard case let .grouped(groups) = fakes.sorted(.byTaxon) else {
            throw MyError.notGrouped
        }
        try #require(groups.count == 1)
        let (family, observations) = try #require(groups.first)
        try #require(family == fake.family)
        try #require(observations.count == 1)
        #expect(try #require(observations.first).comName == fake.comName)
    }

    @Test func byTime() throws {
        guard case let .sorted(actual) = fakeObservations.sorted(.byTime) else {
            throw MyError.notSorted
        }
        try #require(actual.count == fakeObservations.count)
        _ = try actual.reduce(Date.distantFuture) { prev, curr in
            try #require(prev >= curr.obsDt)
            return curr.obsDt
        }
    }

    @Test func byName() throws {
        guard case let .sorted(actual) = fakeObservations.sorted(.byName) else {
            throw MyError.notSorted
        }
        try #require(actual.count == fakeObservations.count)
        _ = try actual.reduce("") { prev, curr in
            try #require(prev <= curr.comName)
            return curr.comName
        }
    }

    @Test func byTaxon() throws {
        guard case let .grouped(actual) = fakeObservations.sorted(.byTaxon) else {
            throw MyError.notGrouped
        }
        try #require(
            actual.reduce(0) { $0 + $1.1.count } == fakeObservations.count
        )
        var prevFamily: eBirdFamily?
        for (family, observations) in actual {
            if let prevFamily {
                try #require(prevFamily < family)
            }
            try #require(!observations.isEmpty)
            var prevOrder = 0.0
            for obs in observations {
                try #require(obs.family == family)
                try #require(prevOrder <= obs.taxonOrder)
                prevOrder = obs.taxonOrder
            }
            prevFamily = family
        }
    }
}

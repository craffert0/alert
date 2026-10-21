// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import Foundation
import RegexBuilder
import Schema
import Testing

struct GeoMatcherTest {
    private func match(_ g: GeoMatcher, _ s: String, _ lat: Double, _ lng: Double) -> Bool {
        let mm = g.matches(in: s)
        guard let m = mm.first else {
            print("== ERROR == [\(s)] -> nil")
            return false
        }
        if m.latitude == lat, m.longitude == lng {
            return true
        } else {
            print("== ERROR == [\(s)] -> \(m.latitude), \(m.longitude)")
            return false
        }
    }

    private func nomatch(_ g: GeoMatcher, _ s: String) -> Bool {
        let mm = g.matches(in: s)
        for m in mm {
            print("== ERROR == [\(s)] -> \(m.latitude), \(m.longitude)")
        }
        return mm.isEmpty
    }

    @Test func bareNumbers() {
        #expect(match(.numbers, "40.6750, -73.9693", 40.6750, -73.9693))
        #expect(match(.numbers, "-40.6750, -73.9693", -40.6750, -73.9693))
        #expect(match(.numbers, "-40.6750, 73.9693", -40.6750, 73.9693))
        #expect(match(.numbers, "-40.6750, 144.675", -40.6750, 144.675))

        #expect(nomatch(.numbers, "91.6750, 144.675"))
        #expect(nomatch(.numbers, "-91.6750, 144.675"))
        #expect(nomatch(.numbers, "-40.6750, 184.675"))
        #expect(nomatch(.numbers, "-40.6750, -184.675"))
    }

    @Test func numberWithQuadrant() {
        #expect(match(.compass, "40.675N, 73.969W", 40.675, -73.969))
        #expect(match(.compass, "40.675 N, 73.969 W", 40.675, -73.969))

        #expect(nomatch(.compass, "90.675N, 73.969W"))
        #expect(nomatch(.compass, "40.675 N, 183.969 W"))
    }

    @Test func byDegrees() {
        #expect(match(.degrees, "42°28'45.4\"N, 76°27'02.1\"W",
                      42.47927777777778, -76.45058333333334))
        #expect(match(.degrees, "42°28'45.4\" N, 76°27'02.1\" W",
                      42.47927777777778, -76.45058333333334))
        #expect(match(.degrees, "42°28'45.4\" N, 76°27'02.1\"W",
                      42.47927777777778, -76.45058333333334))
        #expect(match(.degrees, "42°28'45.4\"N, 76°27'02.1\" W",
                      42.47927777777778, -76.45058333333334))

        #expect(match(.degrees, "42°28'45\"N, 76°27'02\"W",
                      42.47916666666667, -76.45055555555555))

        #expect(nomatch(.degrees, "42°28'N, 76°27'W"))

        #expect(nomatch(.degrees, "92°28'45.4\"N, 76°27'02.1\" W"))
        #expect(nomatch(.degrees, "42°28'45.4\"N, 186°27'02.1\" W"))
    }
}

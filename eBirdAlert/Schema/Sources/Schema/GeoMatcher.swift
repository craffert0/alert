// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

import RegexBuilder

public enum GeoMatcher: CaseIterable {
    case degrees, compass, numbers
}

public extension GeoMatcher {
    struct Match {
        public let string: any StringProtocol
        public let range: Range<String.Index>
        public let latitude: Double
        public let longitude: Double
    }

    func matches(in s: String) -> [Match] {
        switch self {
        case .degrees:
            // 40°40'30.3"N 73°58'09.8"W
            s.matches(of: Regex {
                Anchor.wordBoundary
                regexDegrees(.latitude)
                comma()
                regexDegrees(.longitude)
            }).map { m in
                Match(string: m.0,
                      range: m.range,
                      latitude: (m.1 + m.2 + m.3) * m.4,
                      longitude: (m.5 + m.6 + m.7) * m.8)
            }
        case .compass:
            // 40.675075N, 73.969392W
            s.matches(of: Regex {
                Anchor.wordBoundary
                regexCompass(.latitude)
                comma()
                regexCompass(.longitude)
            }).map { m in
                Match(string: m.0,
                      range: m.range,
                      latitude: m.1 * m.2,
                      longitude: m.3 * m.4)
            }
        case .numbers:
            // 40.675075, -73.969392
            s.matches(of: Regex {
                Anchor.wordBoundary
                negativeDouble(90)
                comma()
                negativeDouble(180)
            }).map { m in
                Match(string: m.0,
                      range: m.range,
                      latitude: m.1,
                      longitude: m.2)
            }
        }
    }
}

private struct Direction {
    let max: Double
    let positive: String
    let negative: String

    static let latitude = Direction(max: 90, positive: "N", negative: "S")
    static let longitude = Direction(max: 180, positive: "E", negative: "W")
}

private func regexDegrees(_ direction: Direction)
    -> Regex<(Substring, Double, Double, Double, Double)>
{
    Regex {
        int(direction.max); "°"
        ZeroOrMore(.whitespace); int(60, factor: 60); "'"
        ZeroOrMore(.whitespace); double(60, factor: 3600); "\""
        ZeroOrMore(.whitespace); northSouth(direction)
    }
}

private func regexCompass(_ direction: Direction)
    -> Regex<(Substring, Double, Double)>
{
    Regex {
        double(direction.max)
        ZeroOrMore(.whitespace); northSouth(direction)
    }
}

private func int(_ max: Double, factor: Double = 1.0)
    -> TryCapture<(Substring, Double)>
{
    TryCapture {
        OneOrMore(.digit, .possessive)
    } transform: {
        $0.asDouble(max, factor: factor)
    }
}

private func double(_ max: Double, factor: Double = 1.0)
    -> TryCapture<(Substring, Double)>
{
    TryCapture {
        OneOrMore(.digit, .possessive)
        Optionally { "."; ZeroOrMore(.digit, .possessive) }
    } transform: {
        $0.asDouble(max, factor: factor)
    }
}

private func negativeDouble(_ max: Double)
    -> TryCapture<(Substring, Double)>
{
    TryCapture {
        Optionally { "-" }
        OneOrMore(.digit, .possessive)
        Optionally { "."; ZeroOrMore(.digit, .possessive) }
    } transform: {
        $0.asDouble(max, factor: 1.0)
    }
}

private func northSouth(_ direction: Direction)
    -> TryCapture<(Substring, Double)>
{
    TryCapture {
        ChoiceOf {
            direction.positive
            direction.negative
        }
    } transform: {
        $0 == direction.positive ? 1.0 : -1.0
    }
}

private func comma() -> Regex<Substring> {
    Regex {
        ZeroOrMore(.whitespace)
        ","
        ZeroOrMore(.whitespace)
    }
}

private extension Substring {
    func asDouble(_ max: Double, factor: Double) -> Double? {
        if let d = Double(self), d <= max, -max <= d {
            d / factor
        } else {
            nil
        }
    }
}

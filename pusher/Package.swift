// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Pusher",

    platforms: [.macOS(.v15)],

    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.3.0"
        ),
        .package(
            url: "https://github.com/swift-server-community/APNSwift.git",
            from: "6.0.0"
        ),
        .package(
            url: "https://github.com/swhitty/FlyingFox.git",
            .upToNextMajor(from: "0.26.0")
        ),
    ],

    targets: [
        .executableTarget(
            name: "TestPusher",
            dependencies: [
                .product(name: "ArgumentParser",
                         package: "swift-argument-parser"),
                .product(name: "APNS",
                         package: "APNSwift"),
            ]
        ),
        .executableTarget(
            name: "TestListener",
            dependencies: [
                .product(name: "ArgumentParser",
                         package: "swift-argument-parser"),
                .product(name: "FlyingFox",
                         package: "FlyingFox"),
            ]
        ),
        .testTarget(
            name: "PusherTests",
            dependencies: [
                // "Pusher"
            ]
        ),
    ]
)

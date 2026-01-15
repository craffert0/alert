// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BirdService",
    platforms: [
        .macOS(.v15),
    ],
    dependencies: [
        .package(path: "../AlertAPI"),
        .package(path: "../Schema"),
        .package(path: "../URLNetwork"),
        .package(
            url: "https://github.com/swift-server-community/APNSwift",
            .upToNextMinor(from: "6.3.0")
        ),
        .package(
            url: "https://github.com/vapor/vapor",
            .upToNextMajor(from: "4.120.0")
        ),
        .package(
            url: "https://github.com/swift-server/swift-openapi-vapor",
            .upToNextMinor(from: "1.0.1")
        ),
        .package(
            url: "https://github.com/vapor/fluent",
            .upToNextMajor(from: "4.13.0")
        ),
        .package(
            url: "https://github.com/vapor/fluent-sqlite-driver",
            .upToNextMajor(from: "4.8.1")
        ),
        .package(
            url: "https://github.com/Brightify/Cuckoo",
            .upToNextMajor(from: "2.2.0")
        ),
    ],
    targets: [
        .executableTarget(
            name: "BirdService",
            dependencies: [
                "AlertAPI",
                "Schema",
                "URLNetwork",
                .product(
                    name: "APNS",
                    package: "APNSwift"
                ),
                .product(
                    name: "OpenAPIVapor",
                    package: "swift-openapi-vapor"
                ),
                .product(
                    name: "Vapor",
                    package: "vapor"
                ),
                .product(
                    name: "Fluent",
                    package: "fluent"
                ),
                .product(
                    name: "FluentSQLiteDriver",
                    package: "fluent-sqlite-driver"
                ),
            ]
        ),
        .testTarget(
            name: "BirdServiceTests",
            dependencies: [
                "BirdService",
                .product(
                    name: "Cuckoo",
                    package: "Cuckoo"
                ),
            ],
            plugins: [
                .plugin(name: "CuckooPluginSingleFile",
                        package: "Cuckoo"),
            ]
        ),
    ]
)

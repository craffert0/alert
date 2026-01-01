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
        .package(
            url: "https://github.com/apple/swift-openapi-generator",
            .upToNextMinor(from: "1.10.3")
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime",
            .upToNextMinor(from: "1.9.0")
        ),
        .package(
            url: "https://github.com/swift-server/swift-openapi-vapor",
            .upToNextMinor(from: "1.0.1")
        ),
        .package(
            url: "https://github.com/vapor/vapor",
            .upToNextMajor(from: "4.120.0")
        ),
    ],
    targets: [
        .executableTarget(
            name: "BirdService",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(
                    name: "OpenAPIVapor",
                    package: "swift-openapi-vapor"
                ),
                .product(
                    name: "Vapor",
                    package: "vapor"
                ),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator",
                        package: "swift-openapi-generator"),
            ]
        ),
    ]
)

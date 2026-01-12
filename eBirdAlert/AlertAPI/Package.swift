// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AlertAPI",

    platforms: [.iOS(.v17), .macOS(.v14)],

    products: [
        .library(
            name: "AlertAPI",
            targets: ["AlertAPI"]
        ),
    ],

    dependencies: [
        .package(path: "../Schema"),
        .package(
            url: "https://github.com/apple/swift-openapi-generator",
            .upToNextMinor(from: "1.10.3")
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime",
            .upToNextMinor(from: "1.9.0")
        ),
    ],

    targets: [
        .target(
            name: "AlertAPI",
            dependencies: [
                "Schema",
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator",
                        package: "swift-openapi-generator"),
            ]
        ),
        .testTarget(
            name: "AlertAPITests",
            dependencies: [
                "AlertAPI",
            ]
        ),
    ]
)

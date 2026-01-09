// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2026 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "URLNetwork",

    platforms: [.iOS(.v17), .macOS(.v14)],

    products: [
        .library(
            name: "URLNetwork",
            targets: ["URLNetwork"]
        ),
    ],

    dependencies: [
        .package(path: "../Schema"),
    ],

    targets: [
        .target(
            name: "URLNetwork",
            dependencies: [
                "Schema",
            ]
        ),
    ]
)

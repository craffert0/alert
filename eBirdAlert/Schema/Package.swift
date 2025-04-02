// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Schema",

    platforms: [.iOS(.v17), .macOS(.v14)],

    products: [
        .library(
            name: "Schema",
            targets: ["Schema"]
        ),
    ],

    dependencies: [
    ],

    targets: [
        .target(
            name: "Schema"
        ),
        .testTarget(
            name: "SchemaTests",
            dependencies: ["Schema"],
            resources: [
                .process("Observations/20250402T1030.json"),
                .process("Checklists/S222144997.json"),
                .process("Checklists/S222159728.json"),
                .process("Checklists/S222245597.json"),
            ]
        ),
    ]
)

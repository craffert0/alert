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
        .package(
            url: "git@gitlab.com:craffert0/swiftutil.git",
            .upToNextMajor(from: "1.0.0")
        ),
    ],

    targets: [
        .target(
            name: "Schema",
            dependencies: [
                .product(
                    name: "SwiftUtil",
                    package: "swiftutil"
                ),
            ]
        ),
        .testTarget(
            name: "SchemaTests",
            dependencies: ["Schema"],
            resources: [
                .process("Observations/20250402T1030.json"),
                .process("Observations/20250402T1638.json"),
                .process("Checklists/S222144997.json"),
                .process("Checklists/S222159728.json"),
                .process("Checklists/S222245597.json"),
                .process("Checklists/S273904108.json"),
                .process("Others/SampleRegionData.json"),
                .process("../../../eBirdAlert/Assets/regions.csv"),
                .process("../../../eBirdAlert/Assets/taxonomy.json"),
            ]
        ),
    ]
)

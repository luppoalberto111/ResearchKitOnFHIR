// swift-tools-version:5.6

//
// This source file is part of the ResearchKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "ResearchKitOnFHIR",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "ResearchKitOnFHIR", targets: ["ResearchKitOnFHIR"]),
        .library(name: "FHIRQuestionnaires", targets: ["FHIRQuestionnaires"])
    ],
    dependencies: [
        .package(url: "https://github.com/PSchmiedmayer/ResearchKit.git", from: "2.1.2"),
        .package(url: "https://github.com/apple/FHIRModels.git", .upToNextMajor(from: "0.4.0"))
    ],
    targets: [
        .target(
            name: "ResearchKitOnFHIR",
            dependencies: [
                .product(name: "ResearchKit", package: "ResearchKit"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ]
        ),
        .target(
            name: "FHIRQuestionnaires",
            dependencies: [
                .product(name: "ModelsR4", package: "FHIRModels")
            ],
            resources: [
                .copy("Resources/SkipLogicExample.json"),
                .copy("Resources/TextValidationExample.json"),
                .copy("Resources/ContainedValueSetExample.json")
            ]
        ),
        .testTarget(
            name: "ResearchKitOnFHIRTests",
            dependencies: [
                .target(name: "ResearchKitOnFHIR"),
                .target(name: "FHIRQuestionnaires")
            ]
        )
    ]
)

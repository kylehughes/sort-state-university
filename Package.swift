// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "sort-state-university",
    platforms: [
        .iOS(.v14),
        // Need to drop macOS down a version until GitHub Actions can support macOS 11
        .macOS(.v10_15),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(
            name: "SortStateUniversity",
            targets: [
                "SortStateUniversity",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SortStateUniversity",
            dependencies: []
        ),
        .testTarget(
            name: "SortStateUniversityTests",
            dependencies: [
                "SortStateUniversity",
            ]
        ),
    ]
)

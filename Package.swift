// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "sort-state-university",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
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

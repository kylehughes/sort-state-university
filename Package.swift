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
        .executable(
            name: "SortStateUniversityClimber",
            targets: [
                "SortStateUniversityClimber"
            ]
        ),
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
        .executableTarget(
            name: "SortStateUniversityClimber",
            dependencies: [
                "SortStateUniversity"
            ]
        ),
        .testTarget(
            name: "SortStateUniversityTests",
            dependencies: [
                "SortStateUniversity",
            ]
        ),
    ]
)

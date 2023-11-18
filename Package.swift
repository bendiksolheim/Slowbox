// swift-tools-version:5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Slowbox",
    platforms: [ .macOS(.v11) ],
    products: [
        .library(
            name: "Slowbox",
            targets: ["Slowbox"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Slowbox",
            dependencies: []),
        .testTarget(
            name: "SlowboxTests",
            dependencies: ["Slowbox"]),
    ]
)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TermSwift",
    platforms: [ .macOS(.v11) ],
    products: [
        .library(
            name: "TermSwift",
            targets: ["TermSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TermSwift",
            dependencies: []),
        .testTarget(
            name: "TermTests",
            dependencies: ["TermSwift"]),
    ]
)

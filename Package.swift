// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "kwiks-ios-alerts-library",
    platforms: [
        .iOS(.v13) // Minimum supported iOS version
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "kwiks-ios-alerts-library",
            targets: ["kwiks-ios-alerts-library"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "kwiks-ios-alerts-library",
            resources: [
                .process("Resources/Media.xcassets")
            ]),
        .testTarget(
            name: "KwiksAlertsTests",
            dependencies: ["kwiks-ios-alerts-library"]),
    ]
)

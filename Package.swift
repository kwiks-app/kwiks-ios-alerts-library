// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KwiksAlerts",
    platforms: [
        .iOS(.v13) // Minimum supported iOS version
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KwiksAlerts",
            targets: ["KwiksAlerts"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KwiksAlerts"),
        .testTarget(
            name: "KwiksAlertsTests",
            dependencies: ["KwiksAlerts"]),
    ]
)

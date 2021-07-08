// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WPFoundation",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "WPFoundation", targets: ["WPFoundation"]),
    ],
    targets: [
        .target(
            name: "WPFoundation",
            dependencies: [],
            path: "Sources"),
    ]
)

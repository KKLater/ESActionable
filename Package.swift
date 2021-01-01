// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ESActionable",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "ESActionable", targets: ["ESActionable"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "ESActionable", dependencies: []),
        .testTarget(name: "ESActionableTests", dependencies: ["ESActionable"]),
    ]
)

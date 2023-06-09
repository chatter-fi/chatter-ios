// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chatter",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(name: "AppCore", targets: ["AppCore"]),
        .library(name: "AppResources", targets: ["AppResources"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "Utils", targets: ["Utils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nerzh/ton-client-swift", .upToNextMajor(from: "1.12.0")),
    ],
    targets: [
        .target(
            name: "AppCore",
            dependencies: [
                "DesignSystem",
                "Utils",
            ]
        ),
        .target(
            name: "AppResources",
            resources: [.process("Assets")]
        ),
        .target(
            name: "DesignSystem",
            dependencies: [
                "AppResources",
            ]
        ),
        .target(
            name: "Utils",
            dependencies: [
                .product(name: "EverscaleClientSwift", package: "ton-client-swift"),
            ]
        ),
    ]
)

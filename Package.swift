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
        .library(name: "HapticCore", targets: ["HapticCore"]),
        .library(name: "SpeechRecognitionCore", targets: ["SpeechRecognitionCore"]),
        .library(name: "Utils", targets: ["Utils"]),
        .library(name: "WalletCore", targets: ["WalletCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nerzh/ton-client-swift", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/nerzh/swift-extensions-pack", .upToNextMinor(from: "1.3.5")),
    ],
    targets: [
        .target(
            name: "AppCore",
            dependencies: [
                "DesignSystem",
                "HapticCore",
                "SpeechRecognitionCore",
                "Utils",
                "WalletCore",
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
            name: "HapticCore",
            dependencies: []
        ),
        .target(
            name: "SpeechRecognitionCore",
            dependencies: []
        ),
        .target(
            name: "Utils",
            dependencies: [
                .product(name: "EverscaleClientSwift", package: "ton-client-swift"),
            ]
        ),
        .target(
            name: "WalletCore",
            dependencies: [
                .product(name: "EverscaleClientSwift", package: "ton-client-swift"),
                .product(name: "SwiftExtensionsPack", package: "swift-extensions-pack"),
            ]
        ),
    ]
)

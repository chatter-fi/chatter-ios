// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.51.11"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
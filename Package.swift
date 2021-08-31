// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RSDKUtils",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "RSDKUtils",
            targets: ["RSDKUtils"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.1.0"))
    ],
    targets: [
        .target(name: "RSDKUtils"),
        .testTarget(
            name: "Tests",
            dependencies: ["RSDKUtils", "Quick", "Nimble"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "RSDKUtils",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "RSDKUtilsMain",
            targets: ["RSDKUtilsMain"]),
        .library(
            name: "RSDKUtilsTestHelpers",
            targets: ["RSDKUtilsTestHelpers"]),
        .library(
            name: "RSDKUtilsNimble",
            targets: ["RSDKUtilsNimble"]),
        .library(
            name: "RDeviceIdentifier",
            targets: ["RDeviceIdentifier"]),
        .library(
            name: "RLogger",
            targets: ["RLogger"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.1.0"))
    ],
    targets: [
        .target(
            name: "RDeviceIdentifier",
            dependencies: ["RSDKUtilsMain"]),
        .target(name: "RLogger"),
        .target(
            name: "RSDKUtilsMain",
            dependencies: ["RLogger"]),
        .target(
            name: "RSDKUtilsTestHelpers", 
            dependencies: ["RSDKUtilsMain"]),
        .target(
            name: "RSDKUtilsNimble", 
            dependencies: ["RSDKUtilsMain", "Nimble"]),
        .testTarget(
            name: "Tests",
            dependencies: ["RSDKUtilsMain", "RSDKUtilsNimble", "RSDKUtilsTestHelpers", "RDeviceIdentifier", "RLogger", "Quick", "Nimble"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

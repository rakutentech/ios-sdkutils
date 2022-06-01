// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RSDKUtils",
    platforms: [
        .iOS(.v12), .watchOS(.v6), .macOS(.v11)
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
            name: "RLogger",
            targets: ["RLogger"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.1.0"))
    ],
    targets: [
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
            dependencies: ["RSDKUtilsMain", "RSDKUtilsNimble", "RSDKUtilsTestHelpers", "RLogger", "Quick", "Nimble"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

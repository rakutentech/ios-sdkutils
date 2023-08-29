// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RSDKUtils",
    platforms: [
        .iOS(.v12), .watchOS(.v6), .macOS(.v10_13)
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
        .package(url: "https://github.com/Quick/Quick.git", "5.0.0"..<"7.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", "9.1.0"..<"12.2.0")
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

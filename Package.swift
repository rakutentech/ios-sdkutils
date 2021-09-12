// swift-tools-version:5.3
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
            name: "RSDKUtilsTests",
            targets: ["RSDKUtilsTests"]),
        .library(
            name: "RSDKUtilsNimble",
            targets: ["RSDKUtilsNimble"]),
        .library(
            name: "RLogger",
            targets: ["RLogger"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.1.0"))
    ],
    targets: [
        .target(name: "RLogger"),
        .target(
            name: "RSDKUtilsMain",
            dependencies: ["RLogger"]),
        .target(
            name: "RSDKUtilsTests", 
            dependencies: ["RSDKUtilsMain"]),
        .target(
            name: "RSDKUtilsNimble", 
            dependencies: ["RSDKUtilsMain", "Nimble"]),
        .testTarget(
            name: "Tests",
            dependencies: ["RSDKUtilsMain", "RSDKUtilsNimble", "RSDKUtilsTests", "RLogger", "Quick", "Nimble"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

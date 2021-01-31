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
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(name: "RSDKUtils"),
        .testTarget(
            name: "Tests",
            dependencies: ["Quick"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

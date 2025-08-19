// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "IOCContainer",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "IOCContainer",
            targets: ["IOCContainer"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "IOCContainer",
            dependencies: []),
        .testTarget(
            name: "IOCContainerTests",
            dependencies: ["IOCContainer"]),
    ]
)

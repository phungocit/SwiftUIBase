// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIBase",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "SwiftUIBase",
            targets: ["SwiftUIBase"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.0")),
    ],
    targets: [
        .target(
            name: "SwiftUIBase",
            dependencies: ["Alamofire"],
            path: "Sources/"
        ),
        .testTarget(
            name: "SwiftUIBaseTests",
            dependencies: ["SwiftUIBase"]
        ),
    ]
)

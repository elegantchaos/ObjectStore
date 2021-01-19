// swift-tools-version:5.2

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "ObjectStore",
    platforms: [
        .macOS(.v10_13), .iOS(.v13)
    ],
    products: [
        .library(
            name: "ObjectStore",
            targets: ["ObjectStore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/Files.git", from: "1.1.5"),
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.1.2")
    ],
    targets: [
        .target(
            name: "ObjectStore",
            dependencies: ["Files"]),
        .testTarget(
            name: "ObjectStoreTests",
            dependencies: ["ObjectStore", "XCTestExtensions"]),
    ]
)

// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "AudioMaster",
    platforms: [
        .iOS(.v15) // iOS 15 以降
    ],
    products: [
        .library(
            name: "AudioMaster",
            targets: ["AudioMaster"]),
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "AudioMaster",
            dependencies: ["Starscream"],
            resources: [
                .process("./Resources/audio.mp3")
            ]
        ),
        .testTarget(
            name: "AudioMasterTests",
            dependencies: ["AudioMaster"]
        ),
    ]
)

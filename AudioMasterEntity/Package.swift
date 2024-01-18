// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "AudioMaster",
    platforms: [
        .iOS(.v15) // iOS 13 以降
    ],
    products: [
        .library(
            name: "AudioMaster",
            targets: ["AudioMaster"]),
    ],
    
    targets: [
        .target(
            name: "AudioMaster",
            dependencies: [],
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


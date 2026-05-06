// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TouchBarPet",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "TouchBarPet",
            targets: ["TouchBarPet"]
        )
    ],
    targets: [
        .target(
            name: "TouchBarPrivate",
            publicHeadersPath: "include"
        ),
        .executableTarget(
            name: "TouchBarPet",
            dependencies: ["TouchBarPrivate"]
        )
    ]
)

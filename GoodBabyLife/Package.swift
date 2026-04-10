// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GoodBabyLife",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "GoodBabyLifeShared",
            targets: ["GoodBabyLifeShared"]
        ),
    ],
    targets: [
        .target(
            name: "GoodBabyLifeShared",
            path: "Shared"
        ),
    ]
)

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SamoTetris",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SamoTetris",
            targets: ["SamoTetris"]
        )
    ],
    targets: [
        .target(
            name: "SamoTetris",
            path: "ModernTetris",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=minimal"])
            ]
        )
    ]
)

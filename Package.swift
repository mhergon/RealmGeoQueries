// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RealmGeoQueries",
    products: [
        .library(
            name: "RealmGeoQueries",
            targets: ["RealmGeoQueries"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-cocoa.git", from: "4.3.0"),
    ],
    targets: [
        .target(
            name: "RealmGeoQueries",
            dependencies: ["RealmSwift"],
            sources: ["GeoQueries"]
        )
    ]
)

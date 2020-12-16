// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "EggSeed",
  platforms: [
    .macOS(.v10_13)
  ],
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .executable(
      name: "eggseed",
      targets: ["eggseed"]
    ),
    .library(name: "EggSeedKit", targets: ["EggSeedKit"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
    .package(url: "https://github.com/weichsel/ZIPFoundation", .upToNextMajor(from: "0.9.0")),
    .package(url: "https://github.com/mxcl/PromiseKit.git", from: "7.0.0-alpha.3"),
    .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("0.50200.0")),
    .package(name: "mustache", url: "https://github.com/AlwaysRightInstitute/mustache", from: "0.5.9"),
    .package(url: "https://github.com/shibapm/Komondor", from: "1.0.6"), // dev
    .package(url: "https://github.com/eneko/SourceDocs", from: "1.2.1"), // dev
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.47.0"), // dev
    .package(url: "https://github.com/realm/SwiftLint", from: "0.41.0"), // dev
    .package(url: "https://github.com/brightdigit/Rocket", .branch("feature/yams-4.0.0")), // dev
    .package(url: "https://github.com/mattpolzin/swift-test-codecov", .branch("master")) // dev
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "eggseed",
      dependencies: [
        "EggSeedKit"
      ]
    ),
    .target(
      name: "EggSeedKit",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "ZIPFoundation", "PromiseKit", "SwiftSyntax", "mustache"
      ]
    ),
    .testTarget(
      name: "EggSeedTests",
      dependencies: ["eggseed"]
    )
  ]
)

#if canImport(PackageConfig)
  import PackageConfig

  let config = PackageConfiguration([
    "komondor": [
      "pre-push": "swift test --enable-code-coverage --enable-test-discovery",
      "pre-commit": [
        "swift test --enable-code-coverage --enable-test-discovery --generate-linuxmain",
        "swift run swiftformat .",
        "swift run swiftlint autocorrect",
        "swift run sourcedocs generate --spm-module eggseed -r",
        "swift run swiftpmls mine",
        "git add .",
        "swift run swiftformat --lint .",
        "swift run swiftlint"
      ]
    ]
  ]).write()
#endif

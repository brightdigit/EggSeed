// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "EggSeed",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .executable(
      name: "eggseed",
      targets: ["eggseed"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
    .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
    .package(url: "https://github.com/weichsel/ZIPFoundation/", .upToNextMajor(from: "0.9.0")),
    .package(url: "https://github.com/brightdigit/Komondor.git", .branch("feature/platforms-2019")),
    .package(url: "https://github.com/eneko/SourceDocs.git", from: "1.0.0"),
    .package(url: "https://github.com/SwiftPackageIndex/PackageListValidator.git", .branch("release/0.0.1"))
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "eggseed",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "ShellOut", "ZIPFoundation"
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
      "pre-push": "swift test",
      "pre-commit": [
        "swift test  --enable-code-coverage --enable-test-discovery --generate-linuxmain",
        "swift run swiftformat .",
        "swift run swiftlint autocorrect",
        "swift run sourcedocs generate --spm-module eggseed",
        "git add ."
      ]
    ]
  ]).write()
#endif

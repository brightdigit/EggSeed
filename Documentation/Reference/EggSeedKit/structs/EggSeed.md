**STRUCT**

# `EggSeed`

```swift
public struct EggSeed: ParsableCommand, EggSeedConfiguration
```

## Properties
### `license`

```swift
@Option(help: "Software License.") public var license: License = .mit
```

### `platforms`

```swift
@Option(help: "Platforms and OSes") public var platforms: [SupportedPlatform] = []
```

### `ci`

```swift
public var ci: ContinuousIntegration
```

### `template`

```swift
public var template: String = "https://github.com/brightdigit/eggseed-template/archive/master.zip"
```

### `templateURL`

```swift
public var templateURL: URL
```

### `cocoapods`

```swift
public var cocoapods: Bool = false
```

### `komondor`

```swift
public var komondor: Bool = true
```

### `rocket`

```swift
public var rocket: Bool = true
```

### `documentation`

```swift
public var documentation: DocumentationTooling = .sourcedocs
```

### `linters`

```swift
public var linters: StylingToolOption = .all
```

### `packageType`

```swift
@Option(help: "Swift Package Type") public var packageType: SwiftPackageType = .library
```

### `userName`

```swift
@Option(help: "User name or Owner of Repostory.") public var userName: String?
```

### `path`

```swift
@Option(help: "Root path of the Swift Package.") public var path: String?
```

## Methods
### `init()`

```swift
public init()
```

### `main(by:_:)`

```swift
public static func main(by runner: Runner, _ arguments: [String]? = nil)
```

### `run()`

```swift
public func run() throws
```

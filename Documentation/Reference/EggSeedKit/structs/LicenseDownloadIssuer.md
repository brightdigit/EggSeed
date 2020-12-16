**STRUCT**

# `LicenseDownloadIssuer`

```swift
public struct LicenseDownloadIssuer: LicenseIssuer
```

## Properties
### `fileManager`

```swift
public let fileManager = FileManager.default
```

### `baseURL`

```swift
public let baseURL = URL(string: "https://api.github.com/licenses")!
```

## Methods
### `issue(_:to:withSession:usingFullName:_:)`

```swift
public func issue(_ license: License, to destinationURL: URL, withSession session: Session, usingFullName fullName: String, _ completion: @escaping (Error?) -> Void)
```

**PROTOCOL**

# `LicenseIssuer`

```swift
public protocol LicenseIssuer
```

## Methods
### `issue(_:to:withSession:usingFullName:_:)`

```swift
func issue(_ license: License, to destinationURL: URL, withSession session: Session, usingFullName fullName: String, _ completion: @escaping (Error?) -> Void)
```

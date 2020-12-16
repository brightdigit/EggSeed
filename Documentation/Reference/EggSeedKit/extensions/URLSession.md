**EXTENSION**

# `URLSession`
```swift
extension URLSession: Session
```

## Methods
### `decode(_:fromURL:withDecoder:_:)`

```swift
public func decode<Success>(_ type: Success.Type, fromURL url: URL, withDecoder decoder: JSONDecoder, _ completion: @escaping ((Result<Success, Error>) -> Void)) -> Cancellable where Success: Decodable
```

### `downloadURL(_:_:)`

```swift
public func downloadURL(_ url: URL, _ completion: @escaping ((Result<URL, Error>) -> Void)) -> Cancellable
```

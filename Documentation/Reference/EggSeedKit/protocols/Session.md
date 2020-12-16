**PROTOCOL**

# `Session`

```swift
public protocol Session
```

## Methods
### `downloadURL(_:_:)`

```swift
func downloadURL(_ url: URL, _ completion: @escaping ((Result<URL, Error>) -> Void)) -> Cancellable
```

### `decode(_:fromURL:withDecoder:_:)`

```swift
func decode<Success: Decodable>(_ type: Success.Type, fromURL url: URL, withDecoder decoder: JSONDecoder, _ completion: @escaping ((Result<Success, Error>) -> Void)) -> Cancellable
```

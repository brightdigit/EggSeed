**PROTOCOL**

# `Downloader`

```swift
public protocol Downloader
```

## Methods
### `downloadURL(_:with:_:)`

```swift
func downloadURL(
  _ url: URL,
  with session: Session,
  _ completion: @escaping ((Result<URL, Error>) -> Void)
) -> Cancellable
```

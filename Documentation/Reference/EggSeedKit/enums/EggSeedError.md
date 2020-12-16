**ENUM**

# `EggSeedError`

```swift
public enum EggSeedError: Error
```

## Cases
### `missingValue(_:)`

```swift
case missingValue(String)
```

### `downloadFailure(_:)`

```swift
case downloadFailure(Error?)
```

### `invalidData(_:)`

```swift
case invalidData(URL)
```

### `decodeFailure(_:)`

```swift
case decodeFailure(Error)
```

### `extractionFailure(_:)`

```swift
case extractionFailure(Error)
```

### `packageFailure(_:)`

```swift
case packageFailure(Error)
```

### `destinationFailure(_:)`

```swift
case destinationFailure(Error)
```

### `empty`

```swift
case empty
```

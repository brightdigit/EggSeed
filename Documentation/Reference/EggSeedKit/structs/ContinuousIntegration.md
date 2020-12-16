**STRUCT**

# `ContinuousIntegration`

```swift
public struct ContinuousIntegration: OptionSet, ExpressibleByArgument
```

## Properties
### `rawValue`

```swift
public let rawValue: ContinuousIntegrationSystem.RawValue
```

## Methods
### `init(rawValue:)`

```swift
public init(rawValue: RawValue)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| rawValue | The raw value of the option set to create. Each bit of `rawValue` potentially represents an element of the option set, though raw values may include bits that are not defined as distinct values of the `OptionSet` type. |
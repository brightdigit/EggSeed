enum Platform: String {
  case macOS
  case iOS
  case watchOS
  case tvOS
  case ubuntu

  var minimumVersion: Version? {
    guard self != .ubuntu else {
      return nil
    }
    let version: Version?
    switch self {
    case .iOS:
      version = Version(argument: "8.0")
    case .macOS:
      version = Version(argument: "10.10")
    case .tvOS:
      version = Version(argument: "9.0")
    case .watchOS:
      version = Version(argument: "2.0")
    default:
      version = nil
    }
    precondition(version != nil, "Invalid Platform or Version String.")
    return version
  }

  func spmPlatform(fromVersion version: Version) -> String? {
    guard let minimumVersion = self.minimumVersion else {
      return nil
    }

    let actualVersion = max(version, minimumVersion)
    return ".\(rawValue)(\"\(actualVersion)\")"
  }
}

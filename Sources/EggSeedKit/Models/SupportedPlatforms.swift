import ArgumentParser

struct Version: Comparable, CustomStringConvertible {
  var description: String {
    [majorVersion, minorVersion].compactMap { $0 }.map(String.init).joined(separator: ".")
  }

  static func < (lhs: Version, rhs: Version) -> Bool {
    guard lhs.majorVersion == rhs.majorVersion else {
      return lhs.majorVersion < rhs.majorVersion
    }
    guard let lmv = lhs.minorVersion, let rmv = rhs.minorVersion else {
      return lhs.minorVersion == nil || rhs.minorVersion == nil
    }
    return lmv < rmv
  }

  let majorVersion: Int
  let minorVersion: Int?
  init?(argument: String) {
    let components = argument.components(separatedBy: ".").prefix(2)
    let numbers = components.compactMap(Int.init)
    guard let majorVersion = numbers.first, components.count == numbers.count else {
      return nil
    }
    self.majorVersion = majorVersion
    minorVersion = numbers.count > 1 ? numbers.last : nil
  }
}

public struct SupportedPlatform: ExpressibleByArgument {
  public init?(argument: String) {
    let components = argument.components(separatedBy: "v")
    guard components.count < 3 else {
      return nil
    }
    guard let platform = components.first.flatMap(Platform.init) else {
      return nil
    }
    let version: Version?
    if let last = components.last {
      guard let lastVersion = Version(argument: last) else {
        return nil
      }
      version = lastVersion
    } else {
      version = nil
    }
    self.platform = platform
    self.version = version
  }

  let platform: Platform
  let version: Version?

  init(platform: Platform, version: Version?) {
    self.platform = platform
    self.version = version
  }

//  static let macOS = SupportedPlatforms(platform: .macOS)
//  static let iOS = SupportedPlatforms(platform: .iOS)
//  static let watchOS = SupportedPlatforms(platform: .watchOS)
//  static let tvOS = SupportedPlatforms(platform: .tvOS)
//  #warning("allow for multiple versions (ubuntus, amazon, centos)")
//  static let ubuntu = SupportedPlatforms(platform: .ubuntu)
}

// let platforms = Set(arrayLiteral: SupportedPlatform(platform: .iOS, version: "13"))

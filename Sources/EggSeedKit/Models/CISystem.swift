import ArgumentParser
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public enum ContinuousIntegrationSystem: Int, CaseIterable {
  case bitrise = 1
  case travisci = 2
  case github = 4
  case circleci = 8

  static let descriptions: [ContinuousIntegrationSystem: String] = [
    .bitrise: "Bitrise",
    .travisci: "Travis-CI",
    .github: "Github Actions",
    .circleci: "Circle CI"
  ]
}

extension ContinuousIntegrationSystem: ExpressibleByStringLiteral, CustomStringConvertible {
  public typealias StringLiteralType = String

  public init(stringLiteral value: String) {
    let index = Self.descriptions.firstIndex(where: { $0.value == value })
    self = Self.descriptions[index!].key
  }

  public var description: String {
    return Self.descriptions[self]!
  }
}

public struct ContinuousIntegration: OptionSet, ExpressibleByArgument {
  public let rawValue: ContinuousIntegrationSystem.RawValue

  public typealias RawValue = ContinuousIntegrationSystem.RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  public static let bitrise = Self(rawValue: ContinuousIntegrationSystem.bitrise.rawValue)
  public static let travisci = Self(rawValue: ContinuousIntegrationSystem.travisci.rawValue)
  public static let github = Self(rawValue: ContinuousIntegrationSystem.github.rawValue)
  public static let circleci = Self(rawValue: ContinuousIntegrationSystem.circleci.rawValue)
  public static let none = Self()
  public static let all = Self(ContinuousIntegrationSystem.allCases.map { Self(rawValue: $0.rawValue) })
}

protocol CISystem {
  func remove(fromURL url: URL, _ completion: @escaping (Error?) -> Void)
  func verify(atURL url: URL, for platforms: SupportedPlatform, _ completion: @escaping (Error?) -> Void)
}

public extension ContinuousIntegration {
  var list: [ContinuousIntegrationSystem] {
    set {
      self = ContinuousIntegration(rawValue: newValue.map { $0.rawValue }.reduce(0, |))
    }
    get {
      ContinuousIntegrationSystem.allCases.filter { self.rawValue & $0.rawValue == $0.rawValue }
    }
  }
}

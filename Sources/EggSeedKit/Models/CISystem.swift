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

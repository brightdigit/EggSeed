import ArgumentParser
import Foundation

public enum StylingTool: Int, CaseIterable {
  case swiftformat = 1
  case swiftlint = 2
}

public struct StylingToolOption: OptionSet, ExpressibleByArgument {
  public let rawValue: StylingTool.RawValue
  public init(rawValue: StylingTool.RawValue) {
    self.rawValue = rawValue
  }

  public static let swiftformat = Self(rawValue: StylingTool.swiftformat.rawValue)
  public static let swiftlint = Self(rawValue: StylingTool.swiftlint.rawValue)
  public static let none = Self()
  public static let all = Self(StylingTool.allCases.map { Self(rawValue: $0.rawValue) })
}

public enum DocumentationTooling: Int, ExpressibleByArgument {
  case sourcedocs = 1
}

public struct EggSeed: ParsableCommand, EggSeedConfiguration {
  public static var configuration = CommandConfiguration(
    commandName: "eggseed")
  static var runner: Runner!

  static func setupRunner(_ runner: Runner) {
    Self.runner = runner
  }

  public init() {}

  // Licence
  @Option(help: "Software License.") public var license: License?

  // OS
  @Option(help: "Platforms and OSes") public var platforms: [SupportedPlatform]

  // CI
  #warning("Add CI targets")
  @Option(default: ContinuousIntegration.all, help: "Continuous Integration Services")
  public var ci: ContinuousIntegration
  // Template

  // @Option(default:  URL(string: "https://github.com/brightdigit/eggseed-template/archive/master.zip")!, help: "Template URL")
  @Option(default: "https://github.com/brightdigit/eggseed-template/archive/master.zip")
  public var template: String

  public var templateURL: URL {
    return URL(string: template) ?? URL(string: "https://github.com/brightdigit/eggseed-template/archive/master.zip")!
  }

  // cocoapods support
  #warning("Add Cocoapods Support Flag")
  @Flag(help: "Supports Cocoapods")
  public var cocoapods: Bool

  @Option(default: true, help: "Use Komondor")
  public var komondor: Bool

  // sourcedocs or jazzy
  #warning("Add Documentation Tool Option")
  @Option(default: .sourcedocs, help: "Documentation Tool")
  public var documentation: DocumentationTooling?

  // swiftformat or/and swiftlint danger etc...
  #warning("Add Linting Options")
  @Option(default: .all, help: "Formatting, Linters, Styling Tools")
  public var linters: StylingToolOption

  #warning("Allow Multiple Products")
  @Option(default: .library, help: "Swift Package Type") public var packageType: SwiftPackageType
  @Option(help: "User name or Owner of Repostory.") public var userName: String?
  @Option(help: "Root path of the Swift Package.") public var path: String?

  public static func main(by runner: Runner, _ arguments: [String]? = nil) {
    Self.setupRunner(runner)
    return Self.main(arguments)
  }

  public func run() throws {
    let semaphore = DispatchSemaphore(value: 0)
    var error: Error?
    Self.runner.run(withConfiguration: self) {
      error = $0
      semaphore.signal()
    }
    semaphore.wait()
    Self.exit(withError: error)
  }
}

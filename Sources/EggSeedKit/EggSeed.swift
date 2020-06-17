import ArgumentParser
import Foundation

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

  // Template

  // @Option(default:  URL(string: "https://github.com/brightdigit/eggseed-template/archive/master.zip")!, help: "Template URL")
  @Option(default: "https://github.com/brightdigit/eggseed-template/archive/master.zip")
  public var template: String

  public var templateURL: URL {
    return URL(string: template) ?? URL(string: "https://github.com/brightdigit/eggseed-template/archive/master.zip")!
  }

  // cocoapods support
  #warning("Add Cocoapods Support Flag")

  // sourcedocs or jazzy
  #warning("Add Documentation Tool Option")

  // swiftformat or/and swiftlint danger etc...
  #warning("Add Linting Options")

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

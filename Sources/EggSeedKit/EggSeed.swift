import ArgumentParser
import Foundation

public struct EggSeed: ParsableCommand, EggSeedConfiguration {
  static var runner: EggSeedRunner!

  static func setupRunner(_ runner: EggSeedRunner) {
    Self.runner = runner
  }

  public init() {}

  // Licence

  // OS

  // CI

  // Template

  // cocoapods support

  // oses

  // sourcedocs or jazzy

  // swiftformat or/and swiftlint danger etc...

  // named options & executable or library
  @Option(default: .library) public var packageType: SwiftPackageType
  @Option() public var userName: String?
  @Option() public var path: String?

  public static func main(by runner: EggSeedRunner, _ arguments: [String]? = nil) -> Never {
    Self.setupRunner(runner)
    return Self.main(arguments)
  }

  public func run() throws {
    let semaphore = DispatchSemaphore(value: 0)
    var error: Error?
    DispatchQueue.global().async {
      Self.runner.run(withConfiguration: self) {
        error = $0
        semaphore.signal()
      }
    }
    semaphore.wait()
    Self.exit(withError: error)
  }
}

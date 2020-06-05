import ArgumentParser
import Foundation

public struct EggSeed: ParsableCommand, EggSeedConfiguration {
  static var runner: Runner!

  static func setupRunner(_ runner: Runner) {
    Self.runner = runner
  }

  public init() {}

  // Licence
  #warning("Add licence options")

  // OS
  #warning("Add OS targets")

  // CI
  #warning("Add CI targets")

  // Template
  #warning("Add Template URLS")

  // cocoapods support
  #warning("Add Cocoapods Support Flag")

  // sourcedocs or jazzy
  #warning("Add Documentation Tool Option")

  // swiftformat or/and swiftlint danger etc...
  #warning("Add Linting Options")

  #warning("Allow Multiple Products")
  @Option(default: .library) public var packageType: SwiftPackageType
  @Option() public var userName: String?
  @Option() public var path: String?

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

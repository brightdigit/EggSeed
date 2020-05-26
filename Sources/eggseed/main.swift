import ArgumentParser
import Foundation
import ShellOut
import ZIPFoundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
enum Platform: Int, CaseIterable {
  case macOS = 1
  case iOS = 2
  case watchOS = 4
  case tvOS = 8
  case linux = 16
}

struct SupportedPlatforms: OptionSet {
  let rawValue: Platform.RawValue

  init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  init(platform: Platform) {
    rawValue = platform.rawValue
  }

  static let macOS = SupportedPlatforms(platform: .macOS)
  static let iOS = SupportedPlatforms(platform: .iOS)
  static let watchOS = SupportedPlatforms(platform: .watchOS)
  static let tvOS = SupportedPlatforms(platform: .tvOS)
  static let linux = SupportedPlatforms(platform: .linux)

  static let all = SupportedPlatforms(Platform.allCases.map(SupportedPlatforms.init(platform:)))
}

protocol Cancellable {}

enum SwiftPackageType: String, ExpressibleByArgument {
  case library
  case executable
}

protocol TemplateDownloader {
  func download(_ completition: @escaping ((Result<URL, Error>) -> Void)) -> Cancellable
}

protocol TemplateExtractor {
  func extract(fromURL url: URL, toURL url: URL, _ completition: @escaping (Error?) -> Void)
}

protocol SwiftPackageFactory {
  func create(atURL url: URL, withType type: SwiftPackageType, _ completition: @escaping (Error?) -> Void)
}

protocol CISystem {
  func remove(fromURL url: URL, _ completition: @escaping (Error?) -> Void)
  func verify(atURL url: URL, for platforms: SupportedPlatforms, _ completition: @escaping (Error?) -> Void)
}

protocol EggSeedConfiguration {
  var userName: String? { get }
}

protocol EggSeedRunner {
  func run(withConfiguration configuration: EggSeedConfiguration, _ completion: @escaping (EggSeedError?) -> Void)
}

struct EggSeed: ParsableCommand, EggSeedConfiguration {
  static var runner: EggSeedRunner!

  static func setupRunner(_ runner: EggSeedRunner) {
    Self.runner = runner
  }

  @Option(default: .library) var type: SwiftPackageType
  @Option() var userName: String?

  static func main(by runner: EggSeedRunner, _ arguments: [String]? = nil) -> Never {
    Self.setupRunner(runner)
    return Self.main(arguments)
  }

  func run() throws {
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

enum EggSeedError: Error {
  case missingValue(String)
  case downloadFailure(Error?)
  case invalidData(URL)
  case extractionFailure(Error)
  case packageFailure(Error)
}

class Runner: EggSeedRunner {
  func run(withConfiguration configuration: EggSeedConfiguration, _ completion: @escaping (EggSeedError?) -> Void) {
    let url = URL(string: "https://github.com/brightdigit/eggseed-template/archive/master.zip")!
    let filesFilter = [".github/workflows/macOS.yml",
                       ".github/workflows/ubuntu.yml",
                       ".travis.yml",
                       "bitrise.yml",
                       ".circleci/config.yml",
                       "README.md",
                       "LICENSE",
                       "Example/project.yml"]
    let destinationFolderURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

    let packageName = destinationFolderURL.lastPathComponent
    let readUserName = configuration.userName ?? (try? shellOut(to: "git remote get-url origin")).flatMap(URL.init(string:))?.deletingLastPathComponent().lastPathComponent
    guard let userName = readUserName else {
      completion(.missingValue("userName"))
      return
    }
    URLSession.shared.downloadTask(with: url) { destination, _, error in

      guard let url = destination else {
        completion(.downloadFailure(error))
        return
      }
      guard let archive = Archive(url: url, accessMode: .read) else {
        completion(.invalidData(url))
        return
      }
      for item in archive.enumerated() {
        if item.element.type == .file {
          let path = item.element.path.components(separatedBy: "/").dropFirst().joined(separator: "/")
          let url = destinationFolderURL.appendingPathComponent(path)
          do {
            if filesFilter.contains(path) {
              try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
              try archive.extract(item.element) { data in
                if var text = String(data: data, encoding: .utf8) {
                  text = text.replacingOccurrences(of: "_PACKAGE_NAME", with: packageName)
                  text = text.replacingOccurrences(of: "_USER_NAME", with: userName)
                  try text.write(to: url, atomically: true, encoding: .utf8)
                } else {
                  try data.write(to: url)
                }
              }
            } else {
              try archive.extract(item.element, to: url)
            }
          } catch {
            completion(.extractionFailure(error))
            return
          }
        }
      }

      do {
        try shellOut(to: .createSwiftPackage(withType: .library))
      } catch {
        completion(.packageFailure(error))
        return
      }
      completion(nil)
    }.resume()
  }
}

EggSeed.main(by: Runner())
//
// while !isFinished {
//  RunLoop.main.run(until: .distantPast)
// }

// executable or library
// cocoapods support
// oses
// ci support
// sourcedocs or jazzy
// swiftformat or/and swiftlint

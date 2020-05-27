import ArgumentParser
import Foundation
import PromiseKit
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
  @discardableResult
  func downloadURL(_ url: URL, _ completition: @escaping ((Result<URL, Error>) -> Void)) -> Cancellable
}

protocol TemplateExtractorItem {
  var data: Data { get }
  var relativePath: String { get }
}

public struct ArchiveItem: TemplateExtractorItem {
  public let data: Data
  public let relativePath: String
}

protocol TemplateExtractor {
  func extract(fromURL url: URL, toURL url: URL, forEach: (TemplateExtractorItem, (Result<Bool, Error>) -> Void) -> Void, completition: @escaping (Error?) -> Void)
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
  var path: String? { get }
  var packageType: SwiftPackageType { get }
}

protocol EggSeedRunner {
  func run(withConfiguration configuration: EggSeedConfiguration, _ completion: @escaping (EggSeedError?) -> Void)
}

struct EggSeed: ParsableCommand, EggSeedConfiguration {
  static var runner: EggSeedRunner!

  static func setupRunner(_ runner: EggSeedRunner) {
    Self.runner = runner
  }

  // Licence
  // OS
  // CI
  // Template

  // named option
  @Option(default: .library) var packageType: SwiftPackageType
  @Option() var userName: String?
  @Option() var path: String?

  static func main(by runner: EggSeedRunner, _ arguments: [String]? = nil) -> Never {
    Self.setupRunner(runner)
    return Self.main(arguments)
  }

  func run() throws {
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

protocol Gitterface {
  func getRemoteURL(for name: String, at url: URL, _ completion: (Result<URL, Error>) -> Void)
}

enum EggSeedError: Error {
  case missingValue(String)
  case downloadFailure(Error?)
  case invalidData(URL)
  case extractionFailure(Error)
  case packageFailure(Error)
  case empty
}

extension URLSessionDownloadTask: Cancellable {}

struct URLTemplateDownloader: TemplateDownloader {
  func downloadURL(_ url: URL, _ completition: @escaping ((Result<URL, Error>) -> Void)) -> Cancellable {
    let task = URLSession.shared.downloadTask(with: url) { url, _, error in
      let result: Result<URL, Error>
      if let url = url {
        result = .success(url)
      } else {
        result = .failure(error ?? EggSeedError.empty)
      }
      completition(result)
    }
    task.resume()
    return task
  }
}

struct ProcessGitterface: Gitterface {
  func getRemoteURL(for _: String, at url: URL, _ completion: (Result<URL, Error>) -> Void) {
    let result = Result {
      try shellOut(to: "git remote get-url origin", at: url.path)
    }.flatMap { (remoteURLString) -> Result<URL, Error> in
      if let url = URL(string: remoteURLString) {
        return .success(url)
      } else {
        return .failure(EggSeedError.empty)
      }
    }
    completion(result)
  }
}

struct ArchiveExtractor: TemplateExtractor {
  func extract(fromURL sourceURL: URL, toURL destinationURL: URL, forEach: (TemplateExtractorItem, (Result<Bool, Error>) -> Void) -> Void, completition: @escaping (Error?) -> Void) {
    guard let archive = Archive(url: sourceURL, accessMode: .read) else {
      completition(EggSeedError.invalidData(sourceURL))
      return
    }
    let items = archive.enumerated()
    for entryItem in items {
      do {
        try archive.extract(entryItem.element) { data in
          let path = entryItem.element.path.components(separatedBy: "/").dropFirst().joined(separator: "/")
          let item = ArchiveItem(data: data, relativePath: path)
          let destinationFileURL = destinationURL.appendingPathComponent(path)
          if entryItem.element.type == Entry.EntryType.file {
            try? FileManager.default.createDirectory(at: destinationFileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            forEach(item) {
              result in
              if (try? result.get()) != true {
                do {
                  try data.write(to: destinationFileURL)
                } catch {
                  completition(error)
                  return
                }
              }
            }
          }
        }
      } catch {
        completition(error)
        return
      }
    }
    completition(nil)
  }
}

struct ProcessSwiftPackageFactory: SwiftPackageFactory {
  func create(atURL url: URL, withType _: SwiftPackageType, _ completition: @escaping (Error?) -> Void) {
    do {
      try shellOut(to: .createSwiftPackage(withType: .library), at: url.path)
    } catch {
      completition(error)
      return
    }
    completition(nil)
  }
}

class Runner: EggSeedRunner {
  let downloader: TemplateDownloader = URLTemplateDownloader()
  let gitterface: Gitterface = ProcessGitterface()
  let extractor: TemplateExtractor = ArchiveExtractor()
  let packageFactory: SwiftPackageFactory = ProcessSwiftPackageFactory()

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
    let destinationFolderURL = URL(fileURLWithPath: configuration.path ?? FileManager.default.currentDirectoryPath)

    let packageName = destinationFolderURL.lastPathComponent
    let userNameCallback: (@escaping (Result<String, Error>) -> Void) -> Void

    gitterface.getRemoteURL(for: "origin", at: destinationFolderURL) { result in
      let userNameResult: Result<String, Error>
      if let readUserName = configuration.userName {
        userNameResult = .success(readUserName)
      } else {
        userNameResult = result.map {
          $0.deletingLastPathComponent().lastPathComponent
        }
      }

      let userName: String
      do {
        userName = try userNameResult.get()
      } catch {
        completion(.missingValue("userName"))
        return
      }
      self.downloader.downloadURL(url) { download in
        let url: URL
        do {
          url = try download.get()
        } catch {
          completion(.downloadFailure(error))
          return
        }
        //      let arcResult : Result<URL, EggSeedError> = download.mapError(EggSeedError.downloadFailure)
        //        .flatMap{ (url) in
        //
        //          if let archive = Archive(url: url, accessMode: .read) {
        //            return .success(archive)
        //          } else {
        //            return .failure(.invalidData(url))
        //          }
        //      }
        //      let archive : Archive
        //      switch arcResult {
        //      case .success(let value): archive = value
        //      case .failure(let error):
        //        completion(error)
        //        return
        //      }
        self.extractor.extract(fromURL: url, toURL: destinationFolderURL, forEach: { item, completed in
          if filesFilter.contains(item.relativePath), var text = String(data: item.data, encoding: .utf8) {
            text = text.replacingOccurrences(of: "_PACKAGE_NAME", with: packageName)
            text = text.replacingOccurrences(of: "_USER_NAME", with: userName)
            let url = destinationFolderURL.appendingPathComponent(item.relativePath)
            let result = Result<Bool, Error> {
              try text.write(to: url, atomically: true, encoding: .utf8)
              return true
            }
            completed(result)
          } else {
            completed(.success(false))
          }
        }, completition: { error in
          if let error = error {
            completion(.extractionFailure(error))
            return
          }
          self.packageFactory.create(atURL: destinationFolderURL, withType: configuration.packageType) { error in
            completion(
              error.map(
                EggSeedError.packageFailure
              )
            )
          }
            })
      }
    }

//    let readUserName = configuration.userName ??
//      gitterface.getRemoteURL(
//        for: "origin",
//        at: destinationFolderURL)
//        .flatMap(URL.init(string:))?
//        .deletingLastPathComponent()
//        .lastPathComponent
    // (try? shellOut(to: "git remote get-url origin")).flatMap(URL.init(string:))?.deletingLastPathComponent().lastPathComponent
//    guard let userName = readUserName else {
//      completion(.missingValue("userName"))
//      return
//    }

//    URLSession.shared.downloadTask(with: url) { destination, _, error in
//
//      guard let url = destination else {
//        completion(.downloadFailure(error))
//        return
//      }
//      guard let archive = Archive(url: url, accessMode: .read) else {
//        completion(.invalidData(url))
//        return
//      }
//      for item in archive.enumerated() {
//        if item.element.type == .file {
//          let path = item.element.path.components(separatedBy: "/").dropFirst().joined(separator: "/")
//          let url = destinationFolderURL.appendingPathComponent(path)
//          try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
//          do {
//            if filesFilter.contains(path) {
//              try archive.extract(item.element) { data in
//                if var text = String(data: data, encoding: .utf8) {
//                  text = text.replacingOccurrences(of: "_PACKAGE_NAME", with: packageName)
//                  text = text.replacingOccurrences(of: "_USER_NAME", with: userName)
//                  try text.write(to: url, atomically: true, encoding: .utf8)
//                } else {
//                  try data.write(to: url)
//                }
//              }
//            } else {
//              try archive.extract(item.element, to: url)
//            }
//          } catch {
//            completion(.extractionFailure(error))
//            return
//          }
//        }
//      }
//
//      do {
//        try shellOut(to: .createSwiftPackage(withType: .library))
//      } catch {
//        completion(.packageFailure(error))
//        return
//      }
//      completion(nil)
//    }.resume()
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

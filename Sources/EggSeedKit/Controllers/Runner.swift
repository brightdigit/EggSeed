import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public class Runner: EggSeedRunner {
  let session: Session = URLSession.shared
  let downloader: TemplateDownloader = URLTemplateDownloader()
  let gitterface: Gitterface = ProcessGitterface()
  let extractor: TemplateExtractor = ArchiveExtractor()
  let packageFactory: SwiftPackageFactory = ProcessSwiftPackageFactory()

  public init() {}

  public func run(withConfiguration configuration: EggSeedConfiguration, _ completion: @escaping (EggSeedError?) -> Void) {
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
      self.downloader.downloadURL(url, with: self.session) { download in
        let url: URL
        do {
          url = try download.get()
        } catch {
          completion(.downloadFailure(error))
          return
        }
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
  }
}

import Foundation
import PromiseKit

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public class EggSeedRunner: Runner {
  let session: Session = URLSession.shared
  let downloader: Downloader = URLDownloader()
  let gitterface: Gitterface = ProcessGitterface()
  let expander: Expander = ArchiveExpander()
  let packageFactory: PackageFactory = ProcessPackageFactory()

  public init() {}

  public func run(
    withConfiguration configuration: EggSeedConfiguration,
    _ completion: @escaping (EggSeedError?) -> Void
  ) -> Cancellable {
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

    let userNamePromise = Promise<String> { resolver in
      if let readUserName = configuration.userName {
        resolver.fulfill(readUserName)
      } else {
        gitterface.getRemoteURL(for: "origin", at: destinationFolderURL) { result in
          resolver.resolve(result.map {
            $0.deletingLastPathComponent().lastPathComponent
          }.mapError { _ in
            EggSeedError.missingValue("userName")
            })
        }
      }
    }

    let downloadPromise = Promise<URL> { resolver in
      self.downloader.downloadURL(url, with: self.session) { result in
        resolver.resolve(result.mapError { error in
          EggSeedError.downloadFailure(error)
        })
      }
    }

    let queue = DispatchQueue.global(qos: .userInitiated)
    let cancellable = when(fulfilled: userNamePromise, downloadPromise).then(on: queue) { (args) -> Promise<Void> in
      let (userName, url) = args
      return Promise<Void> { resolver in
        self.expander.extract(fromURL: url, toURL: destinationFolderURL, forEach: { item, completed in
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
      }, completion: resolver.resolve)
      }
    }.then(on: queue) { _ in
      Promise { resolver in
        self.packageFactory.create(atURL: destinationFolderURL, withType: configuration.packageType, resolver.resolve)
      }
    }.map(on: queue) { (_) -> EggSeedError? in
      nil
    }
    .recover(only: EggSeedError.self, on: queue) { error -> Promise<EggSeedError?> in
      Promise { resolver in
        resolver.fulfill(error)
      }
    }.done(on: queue, completion)

    return cancellable
  }
}

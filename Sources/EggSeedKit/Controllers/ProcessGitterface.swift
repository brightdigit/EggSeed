import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct ProcessGitterface: Gitterface {
  let launcher: Launcher = ProcessLauncher()
  func getRemoteURL(for _: String, at url: URL, _ completion: @escaping (Result<URL, Error>) -> Void) {
    launcher.bash("git remote get-url origin", at: url) { remoteURLString in
      let result = remoteURLString.map {
        String(bytes: $0, encoding: .utf8)
      }.map {
        $0.flatMap(URL.init)
      }.mapError { $0 as Error }
        .flatMap { (parsedURL) -> Result<URL, Error> in
          guard let url = parsedURL else {
            return .failure(EggSeedError.empty)
          }
          return .success(url)
        }
      completion(result)
    }
  }
}

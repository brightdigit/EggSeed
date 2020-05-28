import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct ProcessGitterface: Gitterface {
  let launcher: Launcher = ProcessLauncher()
  func getRemoteURL(for _: String, at url: URL, _ completion: @escaping (Result<URL, Error>) -> Void) {
    launcher.bash("git remote get-url origin", at: url) { remoteURLString in
      let result: Result<URL, Error> = remoteURLString.map { (data) -> String? in
        String(bytes: data, encoding: .utf8)
      }.map { string in
        string.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap(URL.init(string:))
      }.mapError { (esError) -> Error in
        esError as Error
      }.flatMap { (parsedURL) -> Result<URL, Error> in
        guard let url = parsedURL else {
          return .failure(EggSeedError.empty)
        }
        return .success(url)
      }
      completion(result)
    }
  }
}

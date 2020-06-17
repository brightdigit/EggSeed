import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct ProcessGitterface: Gitterface {
  let launcher: Launcher = ProcessLauncher()
  func getRemote(for _: String, at url: URL, _ completion: @escaping (Result<String, Error>) -> Void) {
    launcher.bash("git remote get-url origin", at: url) { remoteURLString in
      let result: Result<String, Error> = remoteURLString.map { (data) -> String? in
        String(bytes: data, encoding: .utf8)
      }.map { string in
        string.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      }.mapError { (esError) -> Error in
        esError as Error
      }.flatMap { (string) -> Result<String, Error> in
        guard let string = string else {
          return .failure(EggSeedError.empty)
        }
        return .success(string)
      }
      completion(result)
    }
  }
}

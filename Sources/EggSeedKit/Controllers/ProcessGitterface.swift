import Foundation
import ShellOut

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

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

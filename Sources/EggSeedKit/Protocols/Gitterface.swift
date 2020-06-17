import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct InvalidFormatError: Error {}

public struct GitHubSpec {
  let owner: String
  let repo: String

  public init(string: String) throws {
    if let url = URL(string: string) {
      repo = url.deletingPathExtension().lastPathComponent
      owner = url.deletingLastPathComponent().lastPathComponent
    } else {
      guard let components = string.components(separatedBy: ":").last?.components(separatedBy: "/") else {
        throw InvalidFormatError()
      }
      guard components.count == 2 else {
        throw InvalidFormatError()
      }
      guard let owner = components.first else {
        throw InvalidFormatError()
      }
      guard let repo = components.last?.components(separatedBy: ".").first else {
        throw InvalidFormatError()
      }
      self.repo = repo
      self.owner = owner
    }
  }
}

public protocol Gitterface {
  func getRemote(for name: String, at url: URL, _ completion: @escaping (Result<String, Error>) -> Void)
}

public extension Gitterface {
  func getSpecs(for name: String, at url: URL, _ completion: @escaping (Result<GitHubSpec, Error>) -> Void) {
    getRemote(for: name, at: url) { result in
      let newResult = result.flatMap { string in
        Result {
          try GitHubSpec(string: string)
        }
      }
      completion(newResult)
    }
  }
}

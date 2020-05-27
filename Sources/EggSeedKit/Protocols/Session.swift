import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol Session {
  @discardableResult
  func downloadURL(_ url: URL, _ completion: @escaping ((Result<URL, Error>) -> Void)) -> Cancellable
}

extension URLSession: Session {
  @discardableResult
  public func downloadURL(_ url: URL, _ completion: @escaping ((Result<URL, Error>) -> Void)) -> Cancellable {
    let task = downloadTask(with: url) { url, _, error in
      let result: Result<URL, Error>
      if let url = url {
        result = .success(url)
      } else {
        result = .failure(error ?? EggSeedError.empty)
      }
      completion(result)
    }
    task.resume()
    return task
  }
}

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol Session {
  @discardableResult
  func downloadURL(_ url: URL, _ completion: @escaping ((Result<URL, Error>) -> Void)) -> Cancellable

  @discardableResult
  func decode<Success: Decodable>(_ type: Success.Type, fromURL url: URL, withDecoder decoder: JSONDecoder, _ completion: @escaping ((Result<Success, Error>) -> Void)) -> Cancellable
}

extension URLSession: Session {
  public func decode<Success>(_ type: Success.Type, fromURL url: URL, withDecoder decoder: JSONDecoder, _ completion: @escaping ((Result<Success, Error>) -> Void)) -> Cancellable where Success: Decodable {
    let task = dataTask(with: url) { data, _, error in
      let result = Result(success: data, failure: error, fallback: EggSeedError.fallback).flatMap { data in
        Result {
          try decoder.decode(type, from: data)
        }
      }
      completion(result)
    }
    task.resume()
    return task
  }

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

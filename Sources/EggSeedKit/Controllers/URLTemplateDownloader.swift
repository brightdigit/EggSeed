import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

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

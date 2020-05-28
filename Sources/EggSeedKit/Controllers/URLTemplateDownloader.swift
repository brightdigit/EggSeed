import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct URLTemplateDownloader: TemplateDownloader {
  func downloadURL(
    _ url: URL,
    with session: Session,
    _ completition: @escaping ((Result<URL, Error>) -> Void)
  ) -> Cancellable {
    return session.downloadURL(url, completition)
  }
}

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol TemplateDownloader {
  @discardableResult
  func downloadURL(
    _ url: URL,
    with session: Session,
    _ completition: @escaping ((Result<URL, Error>) -> Void)
  ) -> Cancellable
}

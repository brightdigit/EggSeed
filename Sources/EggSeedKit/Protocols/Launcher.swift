import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol Launcher {
  @discardableResult
  func bash(
    _ string: String,
    at url: URL?,
    _ completion: @escaping ((Result<Data, LauncherError>) -> Void)
  ) -> Cancellable
}

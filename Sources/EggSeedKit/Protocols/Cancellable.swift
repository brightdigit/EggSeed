import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol Cancellable {}

extension URLSessionDownloadTask: Cancellable {}

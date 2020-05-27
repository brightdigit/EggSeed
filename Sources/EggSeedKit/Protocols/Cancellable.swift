import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol Cancellable {}

extension URLSessionDownloadTask: Cancellable {}

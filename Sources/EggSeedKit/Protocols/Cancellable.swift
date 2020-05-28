import Foundation
import PromiseKit

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol Cancellable {}

extension URLSessionDownloadTask: Cancellable {}

extension Promise: Cancellable {}

import Foundation
import PromiseKit

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol Cancellable {}

extension URLSessionTask: Cancellable {}

extension Promise: Cancellable {}

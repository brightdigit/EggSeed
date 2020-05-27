import Foundation
import ShellOut

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

import ShellOut
struct ProcessSwiftPackageFactory: SwiftPackageFactory {
  func create(atURL url: URL, withType _: SwiftPackageType, _ completition: @escaping (Error?) -> Void) {
    do {
      try shellOut(to: .createSwiftPackage(withType: .library), at: url.path)
    } catch {
      completition(error)
      return
    }
    completition(nil)
  }
}

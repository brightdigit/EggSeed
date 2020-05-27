import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol SwiftPackageFactory {
  func create(atURL url: URL, withType type: SwiftPackageType, _ completition: @escaping (Error?) -> Void)
}

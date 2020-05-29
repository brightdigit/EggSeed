import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol PackageFactory {
  func create(atURL url: URL, withType type: SwiftPackageType, _ completion: @escaping (Error?) -> Void)
}

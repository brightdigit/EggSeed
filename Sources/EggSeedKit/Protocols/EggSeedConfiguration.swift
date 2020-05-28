import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol EggSeedConfiguration {
  var userName: String? { get }
  var path: String? { get }
  var packageType: SwiftPackageType { get }
}

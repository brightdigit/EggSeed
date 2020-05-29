import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol CISystem {
  func remove(fromURL url: URL, _ completion: @escaping (Error?) -> Void)
  func verify(atURL url: URL, for platforms: SupportedPlatforms, _ completion: @escaping (Error?) -> Void)
}

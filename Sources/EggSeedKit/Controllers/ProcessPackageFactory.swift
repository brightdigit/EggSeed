import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct ProcessPackageFactory: PackageFactory {
  let launcher: Launcher = ProcessLauncher()

  func create(atURL _: URL, withType type: SwiftPackageType, _ completion: @escaping (Error?) -> Void) {
    launcher.bash("swift package init --type \(type.rawValue)", at: nil) {
      completion($0.mapError(EggSeedError.packageFailure).error)
    }
  }
}

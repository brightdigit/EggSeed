import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public enum EggSeedError: Error {
  case missingValue(String)
  case downloadFailure(Error?)
  case invalidData(URL)
  case decodeFailure(Error)
  case extractionFailure(Error)
  case packageFailure(Error)
  case destinationFailure(Error)
  case empty

  static func fallback() -> Error {
    return EggSeedError.empty
  }
}

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public enum EggSeedError: Error {
  case missingValue(String)
  case downloadFailure(Error?)
  case invalidData(URL)
  case extractionFailure(Error)
  case packageFailure(Error)
  case empty
}

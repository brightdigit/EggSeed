import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol Expander {
  func extract(
    fromURL url: URL,
    toURL url: URL,
    forEach: (ExpansionEntry, (Result<Bool, Error>) -> Void) -> Void,
    completition: @escaping (Error?) -> Void
  )
}

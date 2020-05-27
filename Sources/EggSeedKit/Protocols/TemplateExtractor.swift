import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol TemplateExtractor {
  func extract(fromURL url: URL, toURL url: URL, forEach: (TemplateExtractorItem, (Result<Bool, Error>) -> Void) -> Void, completition: @escaping (Error?) -> Void)
}

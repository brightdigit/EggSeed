import Foundation

protocol TemplateExtractorItem {
  var data: Data { get }
  var relativePath: String { get }
}

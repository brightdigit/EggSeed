import Foundation

protocol ExpansionEntry {
  var data: Data { get }
  var relativePath: String { get }
}

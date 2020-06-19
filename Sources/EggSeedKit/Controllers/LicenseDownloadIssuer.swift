import Foundation
import mustache

public struct LicenseData: Codable {
  let body: String
}

public struct LicenseDownloadIssuer: LicenseIssuer {
  public let fileManager: FileManager = FileManager.default
  public let baseURL = URL(string: "https://api.github.com/licenses")!
  public func issue(_ license: License?, to destinationURL: URL, withSession session: Session, usingFullName fullName: String, _ completion: @escaping (Error?) -> Void) {
    guard let license = license else {
      completion(nil)
      return
    }
    let year = Calendar.current.component(.year, from: Date())
    let data = ["year": year, "fullname": fullName] as [String: Any]
    let licenseURL = destinationURL.appendingPathComponent("LICENSE")
    let sourceURL = baseURL.appendingPathComponent(license.rawValue)
    let decoder = JSONDecoder()

    let parser = MustacheParser()
    parser.openCharacter = "["
    parser.closeCharacter = "]"
    session.decode(LicenseData.self, fromURL: sourceURL, withDecoder: decoder) { result in
      let completed = result.map { $0.body.replacingOccurrences(of: "[", with: "[[").replacingOccurrences(of: "]", with: "]]") }.map(parser.parse(string:)).map {
        $0.render(object: data)
      }.flatMap { text in
        Result { try text.write(to: licenseURL, atomically: true, encoding: .utf8) }
      }.mapError(EggSeedError.decodeFailure)
      completion(completed.error)
    }
  }
}

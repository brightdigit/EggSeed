import Foundation

public protocol LicenseIssuer {
  func issue(_ license: License, to destinationURL: URL, withSession session: Session, usingFullName fullName: String, _ completion: @escaping (Error?) -> Void)
}

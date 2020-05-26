import Foundation
import ShellOut
import ZIPFoundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

let filesFilter = [".github/workflows/macOS.yml",
                   ".github/workflows/ubuntu.yml",
                   ".travis.yml",
                   "bitrise.yml",
                   ".circleci/config.yml",
                   "README.md",
                   "LICENSE",
                   "Example/project.yml"]
var isFinished = false
let destinationFolderURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let url = URL(string: "https://github.com/brightdigit/eggseed-template/archive/master.zip")!
let packageName = destinationFolderURL.lastPathComponent
do {
  let userName = URL(string: try shellOut(to: "git remote get-url origin"))!.deletingLastPathComponent().lastPathComponent
  URLSession.shared.downloadTask(with: url) { destination, _, _ in
    guard let url = destination else {
      return
    }
    guard let archive = Archive(url: url, accessMode: .read) else {
      preconditionFailure()
    }
    for item in archive.enumerated() {
      do {
        if item.element.type == .file {
          let path = item.element.path.components(separatedBy: "/").dropFirst().joined(separator: "/")
          let url = destinationFolderURL.appendingPathComponent(path)
          debugPrint(path)
          if filesFilter.contains(path) {
            try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            try archive.extract(item.element) { data in
              if var text = String(data: data, encoding: .utf8) {
                text = text.replacingOccurrences(of: "_PACKAGE_NAME", with: packageName)
                text = text.replacingOccurrences(of: "_USER_NAME", with: userName)
                try text.write(to: url, atomically: true, encoding: .utf8)
              } else {
                try data.write(to: url)
              }
            }
          } else {
            try archive.extract(item.element, to: url)
          }
        }
      } catch {
        debugPrint(error)
        isFinished = true
      }
    }

    try? shellOut(to: .createSwiftPackage(withType: .library))
    isFinished = true

  }.resume()
} catch {
  debugPrint(error)
  isFinished = true
}

while !isFinished {
  RunLoop.main.run(until: .distantPast)
}

// executable or library
// cocoapods support
// oses
// ci support
// sourcedocs or jazzy
// swiftformat or/and swiftlint

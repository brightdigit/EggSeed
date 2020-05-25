import Foundation
import ZIPFoundation

var isFinished = false
let url = URL(string: "https://github.com/brightdigit/eggseed-template/archive/master.zip")!
URLSession.shared.downloadTask(with: url) { (destination, _, error) in
  print(destination)
  guard let url = destination else {
    return
  }
  let archive = Archive(url: url, accessMode: .read)
  archive?.enumerated().map({ (element) in
    debugPrint(element.element.path, element.element.type)
  })
  isFinished = true
  
}.resume()

while (!isFinished) {
  RunLoop.main.run(until: .distantPast)
}
// executable or library
// cocoapods support
// oses
// ci support
// sourcedocs or jazzy
// swiftformat or/and swiftlint

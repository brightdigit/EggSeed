import Foundation

struct LauncherError: Error, CustomStringConvertible {
  let terminationStatus: Int32
  let outputData: Data
  let errorData: Data

  var errorString: String? {
    String(bytes: errorData, encoding: .utf8)
  }

  var outputString: String? {
    String(bytes: outputData, encoding: .utf8)
  }

  var description: String {
    let errorString = self.errorString ?? errorData.description
    let outputString = self.outputString ?? outputData.description
    return "\terminated with \(terminationStatus): (error: \"\(errorString)\", output: \"\(outputString)\""
  }
}

import Foundation

struct LauncherError: Error {
  let terminationStatus: Int32
  let outputData: Data
  let errorData: Data
}

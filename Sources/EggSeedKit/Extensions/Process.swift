import Foundation

extension Process: Cancellable {
  func getResult(
    fromOutput output: FileHandle,
    andError error: FileHandle
  ) -> Result<Data, LauncherError> {
    let outputData = output.readDataToEndOfFile()

    if terminationStatus == 0 {
      return .success(outputData)
    }

    return .failure(LauncherError(
      terminationStatus: terminationStatus,
      outputData: outputData,
      errorData: error.readDataToEndOfFile()
    ))
  }
}

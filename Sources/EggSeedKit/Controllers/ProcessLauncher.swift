import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct ProcessLauncher: Launcher {
  let bashExecutableURL = URL(fileURLWithPath: "/bin/bash")
  func bash(
    _ command: String,
    at url: URL?,
    _ completion: @escaping ((Result<Data, LauncherError>) -> Void)
  ) -> Cancellable {
    let process = Process()
    process.executableURL = bashExecutableURL
    process.arguments = ["-c", command]
    process.currentDirectoryURL = url
    let outputPipe = Pipe()
    process.standardOutput = outputPipe

    let errorPipe = Pipe()
    process.standardError = errorPipe
    process.terminationHandler = { _ in
      completion(
        process.getResult(
          fromOutput: outputPipe.fileHandleForReading,
          andError: errorPipe.fileHandleForReading
        ))
    }
    process.launch()
    return process
  }
}

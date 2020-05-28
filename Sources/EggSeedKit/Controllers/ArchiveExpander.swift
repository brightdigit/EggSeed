import Foundation
import ZIPFoundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct ArchiveExpander: Expander {
  func extract(
    fromURL sourceURL: URL,
    toURL destinationURL: URL,
    forEach: (ExpansionEntry, (Result<Bool, Error>) -> Void) -> Void,
    completition: @escaping (Error?) -> Void
  ) {
    guard let archive = Archive(url: sourceURL, accessMode: .read) else {
      completition(EggSeedError.invalidData(sourceURL))
      return
    }
    let items = archive.enumerated()
    for entryItem in items {
      do {
        _ = try archive.extract(entryItem.element) { data in
          let path = entryItem.element.path.components(separatedBy: "/").dropFirst().joined(separator: "/")
          let item = ArchiveEntry(data: data, relativePath: path)
          let destinationFileURL = destinationURL.appendingPathComponent(path)
          if entryItem.element.type == Entry.EntryType.file {
            try? FileManager.default.createDirectory(
              at: destinationFileURL.deletingLastPathComponent(),
              withIntermediateDirectories: true,
              attributes: nil
            )
            forEach(item) { result in
              if (try? result.get()) != true {
                do {
                  try data.write(to: destinationFileURL)
                } catch {
                  completition(error)
                  return
                }
              }
            }
          }
        }
      } catch {
        completition(error)
        return
      }
    }
    completition(nil)
  }
}

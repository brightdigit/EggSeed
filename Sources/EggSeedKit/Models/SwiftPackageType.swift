import ArgumentParser

public enum SwiftPackageType: String, ExpressibleByArgument {
  case library
  case executable
}

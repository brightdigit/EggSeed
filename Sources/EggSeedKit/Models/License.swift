import ArgumentParser

// swiftlint:disable:identifier_name
public enum License: String, ExpressibleByArgument {
  case agpl3_0 = "agpl-3.0"
  case apache2_0 = "apache-2.0"
  case bsd2clause = "bsd-2-clause"
  case bsd3clause = "bsd-3-clause"
  case cc01_0 = "cc0-1.0"
  case epl2_0 = "epl-2.0"
  case gpl2_0 = "gpl-2.0"
  case gpl3_0 = "gpl-3.0"
  case lgpl2_1 = "lgpl-2.1"
  case lgpl3_0 = "lgpl-3.0"
  case mit
  case mpl2_0 = "mpl-2.0"
  case unlicense
}

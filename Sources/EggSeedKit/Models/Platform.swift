enum Platform: Int, CaseIterable {
  case macOS = 1
  case iOS = 2
  case watchOS = 4
  case tvOS = 8
  case linux = 16
  #warning("allow for multiple versions (ubuntus, amazon, centos)")
}

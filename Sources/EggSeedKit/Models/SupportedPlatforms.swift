struct SupportedPlatforms: OptionSet {
  let rawValue: Platform.RawValue

  init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  init(platform: Platform) {
    rawValue = platform.rawValue
  }

  static let macOS = SupportedPlatforms(platform: .macOS)
  static let iOS = SupportedPlatforms(platform: .iOS)
  static let watchOS = SupportedPlatforms(platform: .watchOS)
  static let tvOS = SupportedPlatforms(platform: .tvOS)
  #warning("allow for multiple versions (ubuntus, amazon, centos)")
  static let linux = SupportedPlatforms(platform: .linux)

  static let all = SupportedPlatforms(Platform.allCases.map(SupportedPlatforms.init(platform:)))
}

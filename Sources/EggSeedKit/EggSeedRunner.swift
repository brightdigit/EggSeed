public protocol EggSeedRunner {
  func run(withConfiguration configuration: EggSeedConfiguration, _ completion: @escaping (EggSeedError?) -> Void)
}

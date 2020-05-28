public protocol Runner {
  @discardableResult
  func run(withConfiguration configuration: EggSeedConfiguration, _ completion: @escaping (EggSeedError?) -> Void) -> Cancellable
}

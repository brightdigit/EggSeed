extension Result {
  init(success: Success?, failure: Failure?, fallback: () -> Failure) {
    if let success = success {
      self = .success(success)
    } else {
      self = .failure(failure ?? fallback())
    }
  }

  var error: Failure? {
    guard case let .failure(error) = self else {
      return nil
    }
    return error
  }
}

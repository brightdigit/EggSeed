extension Result {
  var error: Failure? {
    guard case let .failure(error) = self else {
      return nil
    }
    return error
  }
}

#!/bin/bash

if [[ $TRAVIS_OS_NAME = 'osx' ]]; then
  swiftformat --lint . && swiftlint
elif [[ $TRAVIS_OS_NAME = 'linux' ]]; then
  # What to do in Ubunutu
  RELEASE_DOT=$(lsb_release -sr)
  RELEASE_NUM=${RELEASE_DOT//[-._]/}
  RELEASE_NAME=$(lsb_release -sc)
  export PATH="${PWD}/swift-${SWIFT_VER}-RELEASE-ubuntu${RELEASE_DOT}/usr/bin:$PATH"
fi

swift build
swift test  --enable-code-coverage --enable-test-discovery

if [[ $TRAVIS_OS_NAME = 'osx' ]]; then
  xcrun llvm-cov export -format="lcov" .build/debug/${FRAMEWORK_NAME}PackageTests.xctest/Contents/MacOS/${FRAMEWORK_NAME}PackageTests -instr-profile .build/debug/codecov/default.profdata > info.lcov
  bash <(curl https://codecov.io/bash) -F travis -F macOS -n $TRAVIS_JOB_NUMBER-$TRAVIS_OS_NAME
else
  llvm-cov export -format="lcov" .build/x86_64-unknown-linux-gnu/debug/${FRAMEWORK_NAME}PackageTests.xctest -instr-profile .build/debug/codecov/default.profdata > info.lcov
  bash <(curl https://codecov.io/bash) -F travis -F $RELEASE_NAME -n $TRAVIS_JOB_NUMBER-$TRAVIS_OS_NAME
fi

curl -s https://raw.githubusercontent.com/daveverwer/SwiftPMLibrary/master/script.sh | bash -s -- mine

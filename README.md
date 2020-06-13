<img src="eggseed.svg" height="150px">&nbsp;<img src="word.svg" height="100px">

[![SwiftPM](https://img.shields.io/badge/SPM-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-success?logo=swift)](https://swift.org)
[![Twitter](https://img.shields.io/badge/twitter-@leogdion-blue.svg?style=flat)](http://twitter.com/leogdion)
![GitHub](https://img.shields.io/github/license/brightdigit/EggSeed)
![GitHub issues](https://img.shields.io/github/issues/brightdigit/EggSeed)

[![macOS](https://github.com/brightdigit/EggSeed/workflows/macOS/badge.svg)](https://github.com/brightdigit/EggSeed/actions?query=workflow%3AmacOS)
[![ubuntu](https://github.com/brightdigit/EggSeed/workflows/ubuntu/badge.svg)](https://github.com/brightdigit/EggSeed/actions?query=workflow%3Aubuntu)
[![arm](https://github.com/brightdigit/EggSeed/workflows/arm/badge.svg)](https://github.com/brightdigit/EggSeed/actions?query=workflow%3Aarm)
[![Travis (.com)](https://img.shields.io/travis/com/brightdigit/EggSeed?logo=travis)](https://travis-ci.com/brightdigit/EggSeed)
[![CircleCI](https://img.shields.io/circleci/build/github/brightdigit/EggSeed?label=xenial&logo=circleci&token=8772831917d1744b175dd1d52ded916373f9a3ec)](https://circleci.com/gh/brightdigit/EggSeed)
[![Bitrise](https://img.shields.io/bitrise/238176596b2afbd3?label=macOS&logo=bitrise&token=dRGT3cqlMSHKC93wAK01ww)](https://app.bitrise.io/app/238176596b2afbd3)

[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/EggSeed)](https://codecov.io/gh/brightdigit/EggSeed)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/brightdigit/EggSeed)](https://www.codefactor.io/repository/github/brightdigit/EggSeed)
[![codebeat badge](https://codebeat.co/badges/4f86fb90-f8de-40c5-ab63-e6069cde5002)](https://codebeat.co/projects/github-com-brightdigit-EggSeed-master)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/brightdigit/EggSeed)](https://codeclimate.com/github/brightdigit/EggSeed)
[![Code Climate technical debt](https://img.shields.io/codeclimate/tech-debt/brightdigit/EggSeed?label=debt)](https://codeclimate.com/github/brightdigit/EggSeed)
[![Code Climate issues](https://img.shields.io/codeclimate/issues/brightdigit/EggSeed)](https://codeclimate.com/github/brightdigit/EggSeed)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

---

**EggSeed** is a command-line tool for creating swift pacakges with continous integration support. While `swift package init`, creates simple packages, there is no guarantee that your package will work on everyone else's device. That's where _continuous integration_ goes in. 

By using `eggseed`, you can create a package with full integration into CI services such as: _[GitHub Actions](https://github.com/actions), [Travis-CI](https://travis-ci.com/), [BitRise](https://www.bitrise.io), [CircleCI](https://circleci.com)_ and more. Not only that but **EggSeed** also sets up code documentation, linting, and more...

Check out the [roadmap below](#roadmap) for more details on future integrations.

# Installation

### [Mint](https://github.com/yonaskolb/mint)
```sh
mint install brightdigit/EggSeed
```

### Swift Package Manager

**Use as CLI**

```shell
git clone https://github.com/brightdigit/EggSeed.git
cd EggSeed
swift run eggseed
```

**Use as dependency**

Add the following to your Package.swift file's dependencies:

```swift
.package(url: "https://github.com/brightdigit/EggSeed.git", .branch("master")),
```

And then import wherever needed: `import EggSeed`

# Usage

```
USAGE: eggseed [--package-type <package-type>] [--user-name <user-name>] [--path <path>]

OPTIONS:
  --package-type <package-type>
                          Swift Package Type (default: library)
  --user-name <user-name> User name or Owner of Repostory. 
  --path <path>           Root path of the Swift Package. 
  -h, --help              Show help information.
```

**Eggseed** can be run without any options. However there are a few options which can help customize your package:

## Package Type `--package-type` (library or executable)

Desginates what type of package you are creating.

## User Name `--user-name` 

The owner to user name of the repository. If not specified, EggSeed will attempt to parse the URL for that information.

## Path `--path`

Directory to create the Swift Package in, otherwise use the current directory.

# Documentation

All code [documentation is here.](/Documentation/Reference/README.md)

# Roadmap

Future Released Will Include:

* Choosing a License ([MIT](https://choosealicense.com/licenses/mit/), [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/), [Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/), etc...)
* Choosing Target OS and Version for CI (macOS v10_12, watchOS v6_2, Ubuntu Focal, iOS 12, etc...)
* Choosing CI Services ([GitHub Actions](https://github.com/actions), [Travis-CI](https://travis-ci.com/), [BitRise](https://www.bitrise.io), [CircleCI](https://circleci.com), etc...)
* Custom Template URLs
* Adding [Cocoapod](https://cocoapods.org) Support
* Adding [Carthage](https://github.com/Carthage/Carthage) Support
* Adding [Homebrew](https://brew.sh) Support
* Choosing Code Documentation Tool ([SourceDocs](https://github.com/eneko/SourceDocs), [Jazzy](https://github.com/realm/jazzy), etc...)
* Choosing Linting Support ([SwiftFormat](https://github.com/nicklockwood/SwiftFormat), [SwiftLint](https://github.com/realm/SwiftLint), etc...)
* Allow For Multiple Products On Setup
* Choosing Architecture Support (amd64, aarch64, etc...)
* Support for [Komondor](https://github.com/shibapm/Komondor)
* Support for [Rocket](https://github.com/shibapm/Rocket)
* Support for [Swift Package Index](https://swiftpackageindex.com)
* Automated Code Quality Integrations ([codebeat](https://codebeat.co), [Code Climate](https://codeclimate.com), [Code Factory](https://www.codefactor.io), etc...)
* README template and badges

Feel free to [add an issue for any suggestions](https://github.com/brightdigit/EggSeed/issues).

## Contact

Follow and contact me on [Twitter](http://twitter.com/leogdion). If you find an issue, 
just [open a ticket](https://github.com/brightdigit/EggSeed/issues/new) on it. Pull 
requests are warmly welcome as well.

# License

EggSeed is licensed under the MIT license. See [LICENSE](LICENSE) for more info.

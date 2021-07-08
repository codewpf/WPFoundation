# WPFoundation


<p align="center">
<a href="https://github.com/codewpf/WPFoundation/actions/workflows/main.yml"><img src="https://github.com/codewpf/WPFoundation/actions/workflows/main.yml/badge.svg?branch=dev"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/WPFoundation"><img alt="Cocoapods" src="https://img.shields.io/cocoapods/v/WPFoundation">
<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<br />
<a href="https://github.com/codewpf/WPFoundation/blob/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/WPFoundation"></a>
<a href="https://github.com/codewpf/WPFoundation"><img src="https://img.shields.io/cocoapods/p/WPFoundation"></a>
</p>




WPFoundation is support library.

## Requirements
- iOS 12.0+
- Swift 5.0+

## Installation

There are three ways to use WPFoundation in your project, or directly drag the WPFoundation.swift file into your project:

- using Swift Package Manager
- using CocoaPods
- using Carthage

### Installation with Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

The Package Manager is included in Swift 3.0 and above.

#### Steps

* File > Swift Packages > Add Package Dependency
* Add https://github.com/codewpf/WPFoundation.git
* Select "Up to Next Major" with "1.0.0"

### Installation with CocoaPods
[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

#### Podfile
```
platform :ios, '12.0'
use_frameworks!

target 'target’ do
pod 'WPFoundation'
end
```

### Installation with Carthage (iOS 12.0 +)

[Carthage](https://github.com/Carthage/Carthage) is a lightweight dependency manager for Swift and Objective-C. It leverages CocoaTouch modules and is less invasive than CocoaPods.

To install with carthage, follow the instruction on [Carthage](https://github.com/Carthage/Carthage)

#### Cartfile
```
github "codewpf/WPFoundation"
```

### Import headers in your source files

In the source files where you need to use the library, import the header file:

```swift
import WPFoundation
```

## Contact
Follow and contact me on [Twitter](https://twitter.com/Alex___0394) or [Sina Weibo](http://weibo.com/codewpf ). If you find an issue, just [open a ticket](https://github.com/codewpf/WPFoundation/issues/new). Pull requests are warmly welcome as well.

## License
WPFoundation is released under the MIT license. See LICENSE for details.

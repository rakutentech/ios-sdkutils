![Build Status](https://app.bitrise.io/app/7bb2e98294cf2d27/status.svg?token=ISfEDlJWKck83OBeX4XaEQ&branch=master)

# RSDKUtils
## Rakuten's SDK Team internal utilities module

RSDKUtils module contains useful utilities, extensions, and common classes used in SDK development.

RSDKUtils consists of 4 sub-modules:
* *Main* - Contains the most common utilities for various purposes like networking, data storage, and standard class extensions.
* *TestHelpers* - Contains useful mocks and XCTest extensions.
* *Nimble* - Adds additional Nimble expectations like `toAfterTimeout`.
* *RLogger* - A tool for managing your log messages.

This module supports iOS 11.0 and above. It has been tested with iOS 11.1 and above.

# **How to install**

## Installing with CocoaPods
To use the module in its basic configuration your `Podfile` should contain:

```ruby
# Defined also as 'RSDKUtils/Main'
pod 'RSDKUtils', :git => '~> 2.0'
```

To use other functionalities, add their respective subspec to your `Podfile`:
```ruby
pod 'RSDKUtils/TestHelpers', '~> 2.0'
pod 'RSDKUtils/Nimble', '~> 2.0'
pod 'RSDKUtils/RLogger', '~> 2.0'
```

Run `pod install` to install the module.<br>
More information on installing pods: [https://guides.cocoapods.org/using/getting-started.html](https://guides.cocoapods.org/using/getting-started.html)

## Installing with Swift Package Manager
Open your project settings in Xcode and add a new package in 'Swift Packages' tab:
* Repository URL: `https://github.com/rakutentech/ios-sdkutils.git`
* Version settings: branch `master` or 2.0.0 "Up to Next Major" 

Choose one of the following products for your target:
* RSDKUtilsMain
* RSDKUtilsTestHelpers
* RSDKUtilsNimble
* RLogger

# **Using the SDK**
In order to use available utilities you need to add `import` statement in your source file:

### Installed with Cocoapods
```swift
import RSDKUtils
```

### Installed with SPM
Depending on which product(s) you want to use, add one or more `import`:
```swift
import RSDKUtilsMain
import RSDKUtilsNimble
import RSDKUtilsTestHelpers
import RLogger
```

# **Testing the module**

You can test the module as a Swift Package and as a Cocoapod.

### Test Cococapod
Run `pod install` then open RSDKUtils.xcworkspace and run `Tests` target.

### Test Swift Package
Open `Package.swift` in Xcode, choose iOS Simulator and run `Tests` target. 

⚠️ **WARNING:** Command-line testing is not available at the moment because of bug https://bugs.swift.org/browse/SR-13773
```
swift package clean
swift test -Xswiftc "-sdk" -Xswiftc `xcrun --sdk iphonesimulator --show-sdk-path` -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.5-simulator"
```

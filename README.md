![Build Status](https://app.bitrise.io/app/7bb2e98294cf2d27/status.svg?token=ISfEDlJWKck83OBeX4XaEQ&branch=master)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=rakutentech_ios-sdkutils&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=rakutentech_ios-sdkutils)

# RSDKUtils
## Rakuten's SDK Team internal utilities module

RSDKUtils module contains useful utilities, extensions, and common classes used in SDK development.

RSDKUtils consists of 4 sub-modules:
* *Main* - Contains the most common utilities for various purposes like networking, data storage, and standard class extensions.
* *TestHelpers* - Contains useful mocks and XCTest extensions.
* *Nimble* - Adds additional Nimble expectations like `toAfterTimeout`.
* *RLogger* - A tool for managing your log messages.

This module supports iOS 12.0 and above. It has been tested with iOS 12.0 and above.
This module also supports watchOS 6.0 and above, and it's compatible with extensions.

# **Requirements**

Xcode 12.5.x or Xcode 13+

Swift >= 5.4 is supported.

Note: The SDK may build on earlier Xcode versions but it is not officially supported or tested.

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

⚠️ **WARNING:** Command-line testing is not available at the moment because of bug [https://bugs.swift.org/browse/SR-13773](https://bugs.swift.org/browse/SR-13773)
```
swift package clean
swift test -Xswiftc "-sdk" -Xswiftc `xcrun --sdk iphonesimulator --show-sdk-path` -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.5-simulator"
```

# Troubleshooting

* `dyld: Symbol not found:` error when running tests (Cocoapods version)

This usually happens when `TestHelpers` or `Nimble` subspec is linked only to tests target where Host app target is linked to other RSDKUtils subspec at the same time. More info can be found here: [https://github.com/CocoaPods/CocoaPods/issues/7195](https://github.com/CocoaPods/CocoaPods/issues/7195)<br>
The solution for that is to link `TestHelpers` and `Nimble` spec to the Host app target either explicitly or as a `testspecs`.
```ruby
target 'HostAppTarget'
  pod 'RSDKUtils', '~> 2.0', :testspecs => ['Nimble', 'TestHelpers']
end    
```

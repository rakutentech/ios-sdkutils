## Rakuten's SDK Team internal utilities module

#### Test SPM
**WARNING:** Use RSDKUtils.xcworkspace to test this package. The following method is not available because of bug https://bugs.swift.org/browse/SR-13773
```
swift package clean
swift test -Xswiftc "-sdk" -Xswiftc `xcrun --sdk iphonesimulator --show-sdk-path` -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.5-simulator"
```

### Changelog

#### 1.1.0

- Add `KeyStore` class for securely storing values in the device KeyChain.

#### 1.0.0

- Initial release

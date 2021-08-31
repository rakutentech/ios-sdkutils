## Rakuten's SDK Team internal utilities module

#### Build SPM
`swift build -Xswiftc "-sdk" -Xswiftc `xcrun --sdk iphonesimulator --show-sdk-path` -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.5-simulator"`

### Changelog

#### 1.1.0

- Add `KeyStore` class for securely storing values in the device KeyChain.

#### 1.0.0

- Initial release

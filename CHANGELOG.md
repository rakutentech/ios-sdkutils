# **Changelog**

#### 4.0.0 (TBC)
- Deletion:
    - RLogger deprecated functions were removed.
- Features:
    - Handle the cookies storage in URLSessionMock (SDKCF-5966)

#### 3.0.0 (2022-04-06)
- Features:
    - Align iOS version (SDKCF-5011)
    - Align Swift version support (SDKCF-4824) 
    - Added support for watchOS and extensions (SDKCF-4990) 
    - Added Bundle appex, Optional Wrapped and SHA256 helpers (SDKCF-4901)
- Improve:
    - SDK bundle search extension methods
    - Integrated SonarCloud/SonarQube and completed test coverage (SDKCF-4826)
- Fixes:
    - Fixed missing test file references in the project file

#### 2.1.0 (2021-10-27)
- Features:
    - Added AnalyticsBroadcaster (SDKCF-4383)
    - Added Dictionary and String extensions (SDKCF-4423)
- Improvements:
    - Added missing messages to deprecated RLogger functions
- Fixes:
    - Fixed XCTest linking issue for UI Tests targets

#### 2.0.0 (2021-10-14)
**Breaking change:** Removed obsolete utilities, separated source files into subspecs. Minimum supported iOS version is now 11.0
- Features:
    - Added a lot of new utilities (including RLogger)
    - Added SPM support
    - Added Jazzy documentation (available at https://rakutentech.github.io/ios-sdkutils/)
- Improvements:
    - Divided RSDKUtils into 4 subspecs and 4 SPM products - Main, TestHelpers, Nimble and RLogger
    - Added Bitrise CI

#### 1.1.0

- Add `KeyStore` class for securely storing values in the device KeyChain.

#### 1.0.0

- Initial release

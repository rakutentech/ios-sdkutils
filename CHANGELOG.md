# **Changelog**

## Unreleased
- Features:
    - Retrieve Meta-data for Event Logger (SDKCF-6846)
    - Event Logger Public API & Manager Class (SDKCF-6845)
    - Add App Lifecycle Listener For Event Logger (SDKCF-6850)
    
#### 4.1.0 (2024-04-08)
- Improve:
    - Add Privacy Manifest File (SDKCF-6906)

#### 4.0.2 (2023-08-29)
- Fixes:
    - Set Quick and Nimble versions range in Package.swift (SDKCF-6742)

#### 4.0.1 (2023-08-08)
- Fixes:
    - Fixed Nimble Extensions for Xcode 15 beta 5 (SDKCF-6724)
    - Fixed `fastlane ci` errors (SDKCF-6015)
    - Removed failing test (SDKCF-5988)

#### 4.0.0 (2022-11-09)
- Features:
    - RSDKUtils macOS Support (SDKCF-5397)
    - Handle the cookies storage in URLSessionMock (SDKCF-5966)
    - Add `isRGBAEqual` UIColor extension method
- Improve:
    - Add `customAccountNumber` parameter in AnalyticsBroadcaster (SDKCF-5251)
- Deletion:
    - RLogger deprecated functions were removed (SDKCF-5579)
- Build:
    - Bump Quick to v5.0 (fix for Xcode 13.3)
    - Improvements (SDKCF-5616):
        - xcresulttool GitHub Actions inline test report 
        - Update tests scheme name to fix tests report format
        - Use xcpretty to fix fastlane test report generation format
- CI:
    - xcresulttool GitHub Actions inline test report (SDKCF-5616)

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

import Quick
import Nimble
#if canImport(RSDKUtils)
// Cocoapods version
@testable import class RSDKUtils.RDeviceIdentifier
@testable import struct RSDKUtils.RDeviceIdentifierKeychain
@testable import enum RSDKUtils.RDeviceIdentifierConstants
#else
@testable import RDeviceIdentifier
@testable import RSDKUtilsMain
#endif

// MARK: - RDeviceIdentifierSpec

final class RDeviceIdentifierSpec: QuickSpec {
    override func spec() {
        describe("Test Device Id") {
            beforeEach {
                RDeviceIdentifier.reset()
            }

            it("will not be nil") {
                let udid = RDeviceIdentifier.uniqueDeviceIdentifier
                expect(udid).toNot(beNil())
            }

            it("has length") {
                let udid = RDeviceIdentifier.uniqueDeviceIdentifier
                expect(udid?.count) > 0
            }

            it("should return same value when called twice") {
                let udid = RDeviceIdentifier.uniqueDeviceIdentifier
                expect(udid).to(equal(RDeviceIdentifier.uniqueDeviceIdentifier))
            }
        }

        describe("Test Model Id") {
            it("has model id") {
                let expectedValues = ["i386", "x86_64", "arm64"]
                #if targetEnvironment(simulator)
                expect(expectedValues).to(contain(RDeviceIdentifier.modelIdentifier))
                #else
                expect(expectedValues).toNot(contain(RDeviceIdentifier.modelIdentifier))
                #endif
            }
        }

        describe("Test keychain") {
            var keychain: RDeviceIdentifierKeychain!

            beforeEach {
                keychain = RDeviceIdentifierKeychain()
                keychain.clear()
            }

            it("should get internal access groups") {
                expect(try keychain.getAccessGroups()).toNot(throwError())
                let results = try keychain.getAccessGroups()
                expect(results).toNot(beNil())
                let (internalAccessGroup, defaultAccessGroup) = results!
                expect(internalAccessGroup.isEmpty).to(beFalse())
                let hostBundleId = Bundle.main.bundleIdentifier!
                expect(defaultAccessGroup).to(contain(hostBundleId))
            }

            it("should save and retrieve value to internal access group") {
                let (internalAccessGroup, _) = try keychain.getAccessGroups()!
                let expected = "abc"
                let text = expected.data(using: .utf8)!
                expect(try? keychain.save(data: text, for: internalAccessGroup)).toNot(throwError())
                expect(try? keychain.search(for: internalAccessGroup)).toNot(throwError())
                expect(try? keychain.search(for: internalAccessGroup)).to(equal(text))
            }

            it("should clear keychain for internal access group") {
                let (internalAccessGroup, _) = try keychain.getAccessGroups()!
                let text = "abc".data(using: .utf8)!
                expect(try? keychain.save(data: text, for: internalAccessGroup)).toNot(throwError())
                keychain.clear()
                expect(try? keychain.search(for: internalAccessGroup)).to(beNil())
            }
        }
    }
}

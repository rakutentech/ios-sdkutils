import Quick
import Nimble
#if canImport(RSDKUtils)
// Cocoapods version
@testable import enum RSDKUtils.RDeviceIdentifier
@testable import struct RSDKUtils.RDeviceIdentifierKeychain
@testable import enum RSDKUtils.RDeviceIdentifierError
#else
@testable import RDeviceIdentifier
@testable import RSDKUtilsMain
#endif

// MARK: - RDeviceIdentifierSpec

final class RDeviceIdentifierSpec: QuickSpec {
    let service = "com.rakuten.rdeviceidentifier"
    let accessGroup = "com.rakuten.rdeviceidentifier" // must be in TestHost.entitlements
    var keychain: RDeviceIdentifierKeychain {
        RDeviceIdentifierKeychain(service: service, accessGroup: accessGroup)
    }

    override func spec() {
        describe("Test Device Id") {
            beforeEach {
                self.keychain.clear()
            }

            it("will not be nil") {
                let udid = try? RDeviceIdentifier.getUniqueDeviceIdentifier(service: self.service, accessGroup: self.accessGroup)
                expect(udid).toNot(beNil())
            }

            it("has length") {
                let udid = try? RDeviceIdentifier.getUniqueDeviceIdentifier(service: self.service, accessGroup: self.accessGroup)
                expect(udid?.count) > 0
            }

            it("should return same value when called twice") {
                let udid1 = try? RDeviceIdentifier.getUniqueDeviceIdentifier(service: self.service, accessGroup: self.accessGroup)
                let udid2 = try? RDeviceIdentifier.getUniqueDeviceIdentifier(service: self.service, accessGroup: self.accessGroup)
                expect(udid1).to(equal(udid2))
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
                keychain = self.keychain
                keychain.clear()
            }

            it("should save and retrieve value to same access group") {
                let expected = "abc"
                let text = expected.data(using: .utf8)!
                expect(try keychain.save(data: text, for: self.accessGroup)).toNot(throwError())
                expect(try keychain.search(for: self.accessGroup)).toNot(throwError())
                expect(try keychain.search(for: self.accessGroup)).to(equal(text))
            }

            it("should save to accessGroup1 and not find value on accessGroup2") {
                let expected = "abc"
                let text = expected.data(using: .utf8)!
                let entitledDummyAccessGroup = self.accessGroup + "-dummy"
                expect(try keychain.save(data: text, for: self.accessGroup)).toNot(throwError())
                expect(try keychain.search(for: entitledDummyAccessGroup)).toNot(throwError())
                expect(try keychain.search(for: entitledDummyAccessGroup)).to(beNil())
            }

            it("should throw error for unentitled access group") {
                let unentitledAccessGroup = "no.access.group" // should NOT be in TestHost.entitlements
                let expectedErr = RDeviceIdentifierError.appGroupEntitlements(accessGroup: unentitledAccessGroup)
                expect(try keychain.search(for: unentitledAccessGroup)).to(throwError(expectedErr))
            }

            it("should clear keychain for access group") {
                let text = "abc".data(using: .utf8)!
                expect(try keychain.save(data: text, for: self.accessGroup)).toNot(throwError())
                keychain.clear()
                expect(try keychain.search(for: self.accessGroup)).to(beNil())
            }
        }
    }
}

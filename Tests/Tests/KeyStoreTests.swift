import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class KeyStoreSpec: QuickSpec {
    override func spec() {
        #if !SWIFT_PACKAGE
        // Keychain can't be mocked so the best we can do
        // to isolate the tests is to use a separate
        // keychain service
        let keyStore = KeyStore(service: "unit-tests")

        beforeEach {
            keyStore.empty()
        }

        context("keystore initially empty") {
            it("can retrieve an added key") {
                keyStore.addKey(key: "a-key", for: "key-id")

                expect(keyStore.key(for: "key-id")).to(equal("a-key"))
            }

            it("can remove a key") {
                keyStore.addKey(key: "a-key", for: "key-id")
                keyStore.removeKey(for: "key-id")

                expect(keyStore.key(for: "key-id")).to(beNil())
            }

            it("returns nil when attempt to retrieve a key not in keystore") {
                keyStore.addKey(key: "a-key", for: "key-id")

                expect(keyStore.key(for: "key-id-2")).to(beNil())
            }

            it("can retrieve a key that has been added twice") {
                keyStore.addKey(key: "a-key", for: "key-id")
                keyStore.addKey(key: "a-key", for: "key-id")

                expect(keyStore.key(for: "key-id")).to(equal("a-key"))
            }
        }

        context("keystore has multiple keys") {
            beforeEach {
                keyStore.addKey(key: "a-key-1", for: "key-id-1")
                keyStore.addKey(key: "a-key-2", for: "key-id-2")
                keyStore.addKey(key: "a-key-3", for: "key-id-3")
            }

            it("can retrieve a key") {
                expect(keyStore.key(for: "key-id-1")).to(equal("a-key-1"))
            }

            it("can remove a key") {
                keyStore.removeKey(for: "key-id-1")

                expect(keyStore.key(for: "key-id-1")).to(beNil())
            }

            it("returns nil when attempt to retrieve a key not in keystore") {
                expect(keyStore.key(for: "key-id-4")).to(beNil())
            }
        }
        #endif
    }
}

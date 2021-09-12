import Quick
import Nimble
@testable import struct RSDKUtils.RLogger

class RLoggerSpec: QuickSpec {
    override func spec() {

        describe("RLogger") {

            beforeSuite {
                // context("loggingLevel")
                // it("should return RLoggingLevel.error by default")
                expect(RLogger.loggingLevel).to(equal(.error))
            }

            context("callerModuleName") {
                it("should return RSDKUtils or RSDKUtilsPackageTests (spm)") {
                    expect(["RSDKUtils", "RSDKUtilsPackageTests"]).to(contain(RLogger.callerModuleName))
                }
            }

            context("log(message:)") {
                it("should return message from this level: RLoggingLevel.verbose") {
                    RLogger.loggingLevel = .verbose
                    expect(RLogger.verbose("test")).to(equal("test"))
                    expect(RLogger.debug("test")).to(equal("test"))
                    expect(RLogger.info("test")).to(equal("test"))
                    expect(RLogger.warning("test")).to(equal("test"))
                    expect(RLogger.error("test")).to(equal("test"))
                    expect(RLogger.error("test %@", arguments: "hello")).to(equal("test hello"))
                }

                it("should return message from this level: RLoggingLevel.debug") {
                    RLogger.loggingLevel = .debug
                    expect(RLogger.verbose("test")).to(beNil())
                    expect(RLogger.debug("test")).to(equal("test"))
                    expect(RLogger.info("test")).to(equal("test"))
                    expect(RLogger.warning("test")).to(equal("test"))
                    expect(RLogger.error("test")).to(equal("test"))
                    expect(RLogger.error("test %@", arguments: "hello")).to(equal("test hello"))
                }

                it("should return message from this level: RLoggingLevel.info") {
                    RLogger.loggingLevel = .info
                    expect(RLogger.verbose("test")).to(beNil())
                    expect(RLogger.debug("test")).to(beNil())
                    expect(RLogger.info("test")).to(equal("test"))
                    expect(RLogger.warning("test")).to(equal("test"))
                    expect(RLogger.error("test")).to(equal("test"))
                    expect(RLogger.error("test %@", arguments: "hello")).to(equal("test hello"))
                }

                it("should return message from this level: RLoggingLevel.warning") {
                    RLogger.loggingLevel = .warning
                    expect(RLogger.verbose("test")).to(beNil())
                    expect(RLogger.debug("test")).to(beNil())
                    expect(RLogger.info("test")).to(beNil())
                    expect(RLogger.warning("test")).to(equal("test"))
                    expect(RLogger.error("test")).to(equal("test"))
                    expect(RLogger.error("test %@", arguments: "hello")).to(equal("test hello"))
                }

                it("should return message from this level: RLoggingLevel.error") {
                    RLogger.loggingLevel = .error
                    expect(RLogger.verbose("test")).to(beNil())
                    expect(RLogger.debug("test")).to(beNil())
                    expect(RLogger.info("test")).to(beNil())
                    expect(RLogger.warning("test")).to(beNil())
                    expect(RLogger.error("test")).to(equal("test"))
                    expect(RLogger.error("test %@", arguments: "hello")).to(equal("test hello"))
                }

                it("should return message from this level: RLoggingLevel.none") {
                    RLogger.loggingLevel = .none
                    expect(RLogger.verbose("test")).to(beNil())
                    expect(RLogger.debug("test")).to(beNil())
                    expect(RLogger.info("test")).to(beNil())
                    expect(RLogger.warning("test")).to(beNil())
                    expect(RLogger.error("test")).to(beNil())
                    expect(RLogger.error("test %@", arguments: "hello")).to(beNil())
                }
            }
        }
    }
}

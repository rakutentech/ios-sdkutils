import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

private final class ContainerHandler1: NSObject {}
private final class ContainerHandler2: NSObject {}
private final class ContainerHandler3: NSObject {}

final class AnyDependenciesContainerSpec: QuickSpec {
    override func spec() {
        describe("AnyDependenciesContainer") {
            describe("register") {
                it("should not register an object that is already registered") {
                    let dependenciesContainer = AnyDependenciesContainer()
                    let handler = ContainerHandler1()
                    expect(dependenciesContainer.registerObject(handler)).to(beTrue())
                    expect(dependenciesContainer.registerObject(handler)).to(beFalse())
                }
                it("should not register an object that has the same type") {
                    let dependenciesContainer = AnyDependenciesContainer()
                    let handlerA = ContainerHandler1()
                    let handlerB = ContainerHandler1()
                    expect(dependenciesContainer.registerObject(handlerA)).to(beTrue())
                    expect(dependenciesContainer.registerObject(handlerB)).to(beFalse())
                }
            }
        }

        describe("resolve") {
            it("should return nil when there are not registered dependencies") {
                let dependenciesContainer = AnyDependenciesContainer()
                expect(dependenciesContainer.resolveObject(ContainerHandler1.self)).to(beNil())
                expect(dependenciesContainer.resolveObject(ContainerHandler2.self)).to(beNil())
                expect(dependenciesContainer.resolveObject(ContainerHandler3.self)).to(beNil())
            }
            it("should return nil when the type is not found") {
                let dependenciesContainer = AnyDependenciesContainer()
                dependenciesContainer.registerObject(ContainerHandler2())
                dependenciesContainer.registerObject(ContainerHandler3())
                expect(dependenciesContainer.resolveObject(ContainerHandler1.self)).to(beNil())
            }
            it("should return the correct object when the type is found") {
                let dependenciesContainer = AnyDependenciesContainer()
                let handler1 = ContainerHandler1()
                let handler2 = ContainerHandler2()
                let handler3 = ContainerHandler3()
                expect(dependenciesContainer.registerObject(handler1)).to(beTrue())
                expect(dependenciesContainer.registerObject(handler2)).to(beTrue())
                expect(dependenciesContainer.registerObject(handler3)).to(beTrue())
                expect(dependenciesContainer.resolveObject(ContainerHandler1.self)).to(equal(handler1))
                expect(dependenciesContainer.resolveObject(ContainerHandler2.self)).to(equal(handler2))
                expect(dependenciesContainer.resolveObject(ContainerHandler3.self)).to(equal(handler3))
            }
        }
    }
}

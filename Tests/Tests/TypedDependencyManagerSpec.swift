import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

private protocol SingletonElementType {}
private protocol TransientElementType {}
private class SingletonElement: SingletonElementType {}
private class TransientElement: TransientElementType {}

class TypedDependencyManagerSpec: QuickSpec {

    override func spec() {

        context("TypedDependencyManager") {

            var manager: TypedDependencyManager!
            var container: TypedDependencyManager.Container {
                return TypedDependencyManager.Container([
                    TypedDependencyManager.ContainerElement(type: SingletonElementType.self, factory: { SingletonElement() }),
                    TypedDependencyManager.ContainerElement(type: TransientElementType.self, factory: { TransientElement() }, transient: true)
                ])
            }

            beforeEach {
                manager = TypedDependencyManager()
                manager.appendContainer(container)
            }

            it("will always return the same instance for non-transient element") {
                let instanceOne = manager.resolve(type: SingletonElementType.self)
                let instanceTwo = manager.resolve(type: SingletonElementType.self)

                expect(instanceOne).notTo(beNil())
                expect(instanceOne).to(beIdenticalTo(instanceTwo))
            }

            it("will always return new instance for transient element") {
                let instanceOne = manager.resolve(type: TransientElementType.self)
                let instanceTwo = manager.resolve(type: TransientElementType.self)

                expect(instanceOne).notTo(beNil())
                expect(instanceTwo).notTo(beNil())
                expect(instanceOne).notTo(beIdenticalTo(instanceTwo))
            }

            it("will register using (abstract) type, not factory-used type") {
                let transient = manager.resolve(type: TransientElement.self)
                let singleton = manager.resolve(type: SingletonElement.self)

                expect(transient).to(beNil())
                expect(singleton).to(beNil())
            }

            context("When adding mocks for existing types") {

                class SingletonElementMock: SingletonElementType {}
                class TransientElementMock: TransientElementType {}

                var containerWithMocks: TypedDependencyManager.Container {
                    return TypedDependencyManager.Container([
                        TypedDependencyManager.ContainerElement(type: SingletonElementType.self, factory: { SingletonElementMock() }),
                        TypedDependencyManager.ContainerElement(type: TransientElementType.self, factory: { TransientElementMock() }, transient: true)
                    ])
                }

                beforeEach {
                    manager.appendContainer(containerWithMocks)
                }

                it("will use last registered element (mocked) from container for given type") {
                    let mockedTransient = manager.resolve(type: TransientElementType.self)
                    let mockedSingleton = manager.resolve(type: SingletonElementType.self)

                    expect(mockedTransient).to(beAKindOf(TransientElementMock.self))
                    expect(mockedSingleton).to(beAKindOf(SingletonElementMock.self))
                }
            }
        }
    }
}

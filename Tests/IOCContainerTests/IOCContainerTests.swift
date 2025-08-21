import XCTest
@testable import IOCContainer

final class IOCContainerTests: XCTestCase {
    private var container: IOCContainer!
    private var context: EnvironmentContext!
    
    override func setUp() {
        super.setUp()
        context = EnvironmentContext()
        container = IOCContainer(context: context)
    }
    
    override func tearDown() {
        container.clear()
        container = nil
        context = nil
        super.tearDown()
    }
    
    func testSingletonRegistrationAndRetrieval() throws {
        // Test bean
        class TestBean {
            let value: String
            init(value: String) { self.value = value }
        }
        
        // Bean builder
        class TestBeanBuilder: ServiceProvider {
            func build() throws -> Any {
                return TestBean(value: "test")
            }
        }
        
        // Register bean
        let beanInfo = BeanInformation(
            identifier: "testBean",
            scope: .singleton,
            builder: TestBeanBuilder()
        )
        container.registerBeans([beanInfo])
        
        // Get instance twice to verify singleton behavior
        let instance1: TestBean = try container.getSingleton("testBean")
        let instance2: TestBean = try container.getSingleton("testBean")
        
        XCTAssertEqual(instance1.value, "test")
        XCTAssert(instance1 === instance2, "Singleton instances should be identical")
    }
    
    func testPrototypeRegistrationAndRetrieval() throws {
        class TestPrototype {
            let timestamp: Date
            init() { self.timestamp = Date() }
        }
        
        class TestPrototypeBuilder: ServiceProvider {
            func build() throws -> Any {
                return TestPrototype()
            }
        }
        
        let beanInfo = BeanInformation(
            identifier: "prototypeBean",
            scope: .prototype,
            builder: TestPrototypeBuilder()
        )
        container.registerBeans([beanInfo])
        
        let instance1: TestPrototype = try container.getPrototype("prototypeBean")
        // Small delay to ensure different timestamps
        Thread.sleep(forTimeInterval: 0.001)
        let instance2: TestPrototype = try container.getPrototype("prototypeBean")
        
        XCTAssert(instance1.timestamp != instance2.timestamp, "Prototype instances should be different")
    }
    
    func testBeanNotFound() {
        XCTAssertThrowsError(try container.getSingleton("nonexistentBean") as String) { error in
            guard case IOCContainerError.beanNotFound = error else {
                XCTFail("Expected BeanNotFoundException")
                return
            }
        }
    }
    
    func testCircularDependency() {
        class BeanA {
            let b: BeanB
            init(b: BeanB) { self.b = b }
        }
        
        class BeanB {
            let a: BeanA
            init(a: BeanA) { self.a = a }
        }
        
        class CircularBeanBuilder: ServiceProvider {
            func build() throws -> Any {
                throw IOCContainerError.circularDependency("Circular dependency detected between BeanA and BeanB")
            }
        }
        
        let beanInfo = BeanInformation(
            identifier: "circularBean",
            scope: .singleton,
            builder: CircularBeanBuilder()
        )
        container.registerBeans([beanInfo])
        
        XCTAssertThrowsError(try container.getSingleton("circularBean") as BeanA) { error in
            guard case IOCContainerError.circularDependency = error else {
                XCTFail("Expected CircularDependencyException")
                return
            }
        }
    }
}

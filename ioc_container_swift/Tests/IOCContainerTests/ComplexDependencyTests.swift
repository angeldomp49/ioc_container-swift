import XCTest
@testable import IOCContainer

final class ComplexDependencyTests: XCTestCase {
    // Clases de prueba
    class ServiceA {
        let b: ServiceB
        init(b: ServiceB) { self.b = b }
    }
    
    class ServiceB {
        let c: ServiceC
        init(c: ServiceC) { self.c = c }
    }
    
    class ServiceC {
        let value: String
        init(value: String) { self.value = value }
    }
    
    // Proveedores de servicio
    class ServiceCProvider: ServiceProvider {
        func build(_ args: [Any]) throws -> Any {
            let container = args[0] as! IOCContainer
            let context = container.context
            let value: String = try context.getRequiredValue("service.c.value")
            return ServiceC(value: value)
        }
    }
    
    class ServiceBProvider: ServiceProvider {
        func build(_ args: [Any]) throws -> Any {
            let container = args[0] as! IOCContainer
            let serviceC: ServiceC = try container.getSingleton("serviceC")
            return ServiceB(c: serviceC)
        }
    }
    
    class ServiceAProvider: ServiceProvider {
        func build(_ args: [Any]) throws -> Any {
            let container = args[0] as! IOCContainer
            let serviceB: ServiceB = try container.getSingleton("serviceB")
            return ServiceA(b: serviceB)
        }
    }
    
    func testComplexDependencyResolution() throws {
        // Preparar el contexto con valores necesarios
        let context = EnvironmentContext()
        context.setValue("test value", forKey: "service.c.value")
        
        // Crear la estructura de la aplicación
        let app = ApplicationStructure(context: context)
        
        // Registrar los beans con sus dependencias
        let beans: Set<BeanInformation> = [
            BeanInformation(
                identifier: "serviceC",
                scope: .singleton,
                provider: ServiceCProvider(),
                dependsOn: []
            ),
            BeanInformation(
                identifier: "serviceB",
                scope: .singleton,
                provider: ServiceBProvider(),
                dependsOn: ["serviceC"]
            ),
            BeanInformation(
                identifier: "serviceA",
                scope: .singleton,
                provider: ServiceAProvider(),
                dependsOn: ["serviceB"]
            )
        ]
        
        // Iniciar la aplicación
        try app.start(with: beans)
        
        // Obtener y verificar el servicio A
        let container = try app.getContainer()
        let serviceA: ServiceA = try container.getSingleton("serviceA")
        
        XCTAssertEqual(serviceA.b.c.value, "test value")
    }
    
    func testCircularDependencyDetection() {
        // Clases con dependencia circular
        class CircularA {
            let b: CircularB
            init(b: CircularB) { self.b = b }
        }
        
        class CircularB {
            let a: CircularA
            init(a: CircularA) { self.a = a }
        }
        
        class CircularAProvider: ServiceProvider {
            func build(_ args: [Any]) throws -> Any {
                let container = args[0] as! IOCContainer
                let b: CircularB = try container.getSingleton("circularB")
                return CircularA(b: b)
            }
        }
        
        class CircularBProvider: ServiceProvider {
            func build(_ args: [Any]) throws -> Any {
                let container = args[0] as! IOCContainer
                let a: CircularA = try container.getSingleton("circularA")
                return CircularB(a: a)
            }
        }
        
        // Configurar el contenedor
        let context = EnvironmentContext()
        let app = ApplicationStructure(context: context)
        
        // Registrar beans con dependencia circular
        let beans: Set<BeanInformation> = [
            BeanInformation(
                identifier: "circularA",
                scope: .singleton,
                provider: CircularAProvider(),
                dependsOn: ["circularB"]
            ),
            BeanInformation(
                identifier: "circularB",
                scope: .singleton,
                provider: CircularBProvider(),
                dependsOn: ["circularA"]
            )
        ]
        
        // Verificar que se detecta la dependencia circular
        XCTAssertThrowsError(try app.start(with: beans)) { error in
            guard case IOCContainerError.circularDependency = error else {
                XCTFail("Expected CircularDependencyException")
                return
            }
        }
    }
}

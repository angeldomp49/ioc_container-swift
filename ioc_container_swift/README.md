# IOCContainer para Swift

Un contenedor de inversión de control (IoC) thread-safe para Swift, compatible con iOS 15 y macOS 12 o superior.

## Características

- Gestión de beans singleton y prototype
- Resolución automática de dependencias
- Detección de dependencias circulares
- Sistema de eventos del ciclo de vida de la aplicación
- Contexto de ambiente thread-safe para valores globales
- Soporte para carga de configuración desde JSON y Plist
- Compatible con variables de entorno

## Instalación

Simplemente copia el directorio `lib/swift/main` a tu proyecto y agrégalo como dependencia en tu `Package.swift`:

```swift
dependencies: [
    .package(path: "path/to/IOCContainer")
]
```

## Uso Básico

### 1. Definir tus servicios

```swift
class ServiceA {
    let value: String
    init(value: String) { self.value = value }
}

class ServiceB {
    let serviceA: ServiceA
    init(serviceA: ServiceA) { self.serviceA = serviceA }
}
```

### 2. Crear los proveedores de servicios

```swift
class ServiceAProvider: ServiceProvider {
    func build(_ args: [Any]) throws -> Any {
        return ServiceA(value: "test")
    }
}

class ServiceBProvider: ServiceProvider {
    func build(_ args: [Any]) throws -> Any {
        let container = args[0] as! IOCContainer
        let serviceA: ServiceA = try container.getSingleton("serviceA")
        return ServiceB(serviceA: serviceA)
    }
}
```

### 3. Configurar y usar el contenedor

```swift
// Crear el contexto y la estructura de la aplicación
let context = EnvironmentContext()
let app = ApplicationStructure(context: context)

// Registrar los beans
let beans: Set<BeanInformation> = [
    BeanInformation(
        identifier: "serviceA",
        scope: .singleton,
        provider: ServiceAProvider(),
        dependsOn: []
    ),
    BeanInformation(
        identifier: "serviceB",
        scope: .singleton,
        provider: ServiceBProvider(),
        dependsOn: ["serviceA"]
    )
]

// Iniciar la aplicación
try app.start(with: beans)

// Obtener servicios
let container = try app.getContainer()
let serviceB: ServiceB = try container.getSingleton("serviceB")
```

## Carga de Propiedades

### JSON

```swift
let jsonLoader = JSONPropertyLoader(url: jsonURL)
context.registerPropertyLoader(jsonLoader)
try context.loadProperties()
```

### Plist

```swift
let plistLoader = PlistPropertyLoader(url: plistURL)
context.registerPropertyLoader(plistLoader)
try context.loadProperties()
```

### Variables de Entorno

```swift
let envLoader = EnvironmentPropertyLoader(prefix: "APP_")
context.registerPropertyLoader(envLoader)
try context.loadProperties()
```

## Gestión del Ciclo de Vida

Puedes crear tu propio listener de eventos implementando `ApplicationEventListener`:

```swift
class MyEventListener: ApplicationEventListener {
    func onApplicationStarted(_ container: IOCContainer) {
        print("¡Aplicación iniciada!")
    }
    
    func onApplicationError(_ error: Error, _ container: IOCContainer?) {
        print("Error: \(error)")
    }
}

let app = ApplicationStructure(
    context: context,
    eventListener: MyEventListener()
)
```

## Thread Safety

Todos los componentes principales (`IOCContainer`, `EnvironmentContext`, `SingletonInformation`, `PrototypeInformation`) son thread-safe por diseño, usando `NSLock` para la sincronización.

## Manejo de Errores

La biblioteca utiliza el enum `IOCContainerError` para manejar errores específicos:

- `.beanNotFound`: Cuando no se encuentra un bean solicitado
- `.circularDependency`: Cuando se detecta una dependencia circular
- `.propertiesLoading`: Cuando hay problemas cargando propiedades

## Mejores Prácticas

1. Define claramente las dependencias usando el parámetro `dependsOn`
2. Usa singletons para servicios compartidos y prototypes para instancias únicas
3. Aprovecha el `EnvironmentContext` para valores de configuración
4. Implementa `ApplicationEventListener` para manejar eventos del ciclo de vida
5. Maneja adecuadamente los errores usando try-catch

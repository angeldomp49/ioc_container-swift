import Foundation

public class ApplicationStructure {
    private let context: EnvironmentContext
    private var container: IOCContainer?
    private let eventListener: ApplicationEventListener
    private let lock = NSLock()
    private var isRunning = false
    
    public init(context: EnvironmentContext = EnvironmentContext(),
                eventListener: ApplicationEventListener = DefaultApplicationEventListener()) {
        self.context = context
        self.eventListener = eventListener
    }
    
    public func start(with beans: Set<BeanInformation>) throws {
        lock.lock()
        defer { lock.unlock() }
        
        if isRunning {
            return
        }
        
        do {
            // Inicialización del contenedor
            eventListener.onBeforeContainerInitialization(context)
            let container = IOCContainer(context: context)
            try container.registerBeans(beans)
            self.container = container
            eventListener.onAfterContainerInitialization(container)
            
            // Instanciación de singletons
            eventListener.onBeforeSingletonInstantiation(container)
            try container.instantiateSingletons()
            eventListener.onAfterSingletonInstantiation(container)
            
            isRunning = true
            eventListener.onApplicationStarted(container)
            
        } catch {
            eventListener.onApplicationError(error, container)
            throw error
        }
    }
    
    public func stop() {
        lock.lock()
        defer { lock.unlock() }
        
        if !isRunning {
            return
        }
        
        if let container = container {
            eventListener.onApplicationStopping(container)
            container.clear()
        }
        
        context.clear()
        isRunning = false
    }
    
    public func getContainer() throws -> IOCContainer {
        lock.lock()
        defer { lock.unlock() }
        
        guard let container = container else {
            throw IOCContainerError.beanNotFound("Container not initialized. Call start() first.")
        }
        return container
    }
    
    public func isApplicationRunning() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return isRunning
    }
}

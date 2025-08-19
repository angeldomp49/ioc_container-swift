import Foundation

public protocol ApplicationEventListener {
    func onBeforeContainerInitialization(_ context: EnvironmentContext)
    func onAfterContainerInitialization(_ container: IOCContainer)
    func onBeforeSingletonInstantiation(_ container: IOCContainer)
    func onAfterSingletonInstantiation(_ container: IOCContainer)
    func onApplicationStarted(_ container: IOCContainer)
    func onApplicationStopping(_ container: IOCContainer)
    func onApplicationError(_ error: Error, _ container: IOCContainer?)
}

// Implementación por defecto para hacer opcional la implementación de todos los métodos
public extension ApplicationEventListener {
    func onBeforeContainerInitialization(_ context: EnvironmentContext) {}
    func onAfterContainerInitialization(_ container: IOCContainer) {}
    func onBeforeSingletonInstantiation(_ container: IOCContainer) {}
    func onAfterSingletonInstantiation(_ container: IOCContainer) {}
    func onApplicationStarted(_ container: IOCContainer) {}
    func onApplicationStopping(_ container: IOCContainer) {}
    func onApplicationError(_ error: Error, _ container: IOCContainer?) {}
}

open class DefaultApplicationEventListener: ApplicationEventListener {
    public init() {}
    
    open func onBeforeContainerInitialization(_ context: EnvironmentContext) {
        print("⚡️ Initializing container...")
    }
    
    open func onAfterContainerInitialization(_ container: IOCContainer) {
        print("✅ Container initialized")
    }
    
    open func onBeforeSingletonInstantiation(_ container: IOCContainer) {
        print("⚡️ Creating singleton instances...")
    }
    
    open func onAfterSingletonInstantiation(_ container: IOCContainer) {
        print("✅ Singleton instances created")
    }
    
    open func onApplicationStarted(_ container: IOCContainer) {
        print("🚀 Application started")
    }
    
    open func onApplicationStopping(_ container: IOCContainer) {
        print("🛑 Application stopping...")
    }
    
    open func onApplicationError(_ error: Error, _ container: IOCContainer?) {
        print("❌ Application error: \(error.localizedDescription)")
    }
}
